#include <simage_quicktime.h>

#include <Carbon/Carbon.h>
#include <ApplicationServices/ApplicationServices.h>
#include <QuickTime/ImageCompression.h>    // for image loading 
#include <QuickTime/QuickTimeComponents.h> // for file type support

#include <libgen.h>    
#include <stdlib.h>
#include <sys/param.h>  // for MAXPATHLEN

#define ERR_NO_ERROR    0   // no error
#define ERR_OPEN        1   // could not open file
#define ERR_CG          2   // internal CG error
#define ERR_WRITE       3   // error writing file
#define ERR_UNSUPPORTED 4   // unsupported write format
#define ERR_MEM         5   // out of memory

typedef struct {
  size_t width;
  size_t height;
  size_t numcomponents;
  size_t bitsPerPixel;
  size_t bytesPerRow;
  size_t size;
  unsigned char * data;
} BitmapInfo;

static int quicktimeerror = ERR_NO_ERROR;

// FIXME: Currently, all images are handled as 32bit (i.e. converted
// on import). That seems to be the way to do it for 24bit and 32 bit
// images, but should be done differently for 8bit images (though, note,
// it works perfectly okay is it is.) For some reason, using 
// k8IndexedPixelFormat as an argument when creating the GWorld for 
// importing does not work. Investigate. kyrah 20030210


// -------------------- internal functions ---------------------------


/* Check if there is a valid QuickTime importer that can read file.
 * The following will be tried:
 *  - matching Mac OS file type
 *  - matching the file name suffix
 *  - matching the MIME type
 *  - query each graphics importer component 
 * Returns 1 if an importer was found, and 0 otherwise.
 */
static int
get_importer(const char * filename, GraphicsImportComponent * c) 
{
  FSSpec fss;
  FSRef path;
  FSRef file;
  char fullpath [MAXPATHLEN];
  CFStringRef cfstr;
  UniChar * ustr;
  int len;
  int e = noErr;

  realpath(filename, fullpath);
  FSPathMakeRef((char *)dirname(fullpath), &path, false);

  // convert char * to UniChar *
  cfstr = CFStringCreateWithCString(0, basename(fullpath), 
          CFStringGetSystemEncoding());
  len = CFStringGetLength(cfstr);
  ustr = malloc(len * sizeof(UniChar)); 
  CFStringGetCharacters(cfstr, CFRangeMake(0, len), ustr); 

  FSMakeFSRefUnicode (&path, len, ustr, CFStringGetSystemEncoding(), &file);
  e = FSGetCatalogInfo(&file, kFSCatInfoNone, NULL, NULL, &fss, NULL);
  if (e != noErr) return 0;

  if (GetGraphicsImporterForFile(&fss, c) == noErr) return 1;
  else return 0;
}

/* Look for a valid graphics exporter component for the file extension 
 * "fext," and if we find one, open it.
 */
static void
open_exporter(const char * fext, GraphicsExportComponent * ge)
{ 
  Component c = 0;
  ComponentDescription cd;
  cd.componentType = GraphicsExporterComponentType;
  cd.componentSubType = 0;
  cd.componentManufacturer = 0;
  cd.componentFlags = 0;
  cd.componentFlagsMask = graphicsExporterIsBaseExporter;

  if (!fext || !ge) return;

  while ((c = FindNextComponent (c, &cd)) != 0) {
    char * cstr = malloc(5);
    OSType * ext = malloc(sizeof(OSType));
    GraphicsExportGetDefaultFileNameExtension((GraphicsExportComponent)c, ext);
    memcpy(cstr, ext, 4); 
    if (cstr[3] == ' ') cstr[3] = '\0';
    else cstr[4] = '\0';
    if (strcasecmp(fext, cstr) == 0) {
      OpenAComponent(c, ge);
      break;
    }
  }
}


/* Convert the OSType t to a C string and append it to str.
 * An OSType is really an unsigned long, intepreted as a four-character 
 * constant. 
 */
static void
cfstring_append_ostype(CFMutableStringRef str, OSType * t) 
{
  char * cstr;
  if (!t) return;
  cstr = malloc(5);
  memcpy(cstr, t, 4); 
  if (cstr[3] == ' ') cstr[3] = '\0';
  else cstr[4] = '\0';
  CFStringAppendCString(str, cstr, CFStringGetSystemEncoding());
  free(cstr);
}


/* Create a new file named "file" in the current working directory.
 * If a file with this name already exists, it will be overwritten.
 * Returns 1 if file could be created successfully, and 0 otherwise.
 */
static int
create_file(const char * filename, FSSpec * fss) 
{
  FSRef path;
  FSRef file;
  CFStringRef cfstr;
  UniChar * ustr;
  int e = noErr;
  CFIndex len;
  char fullpath [MAXPATHLEN];

  realpath(filename, fullpath);
  e = FSPathMakeRef((char *)dirname(fullpath), &path, false);
  if (e != noErr) return 0;

  // convert char * to UniChar *
  cfstr = CFStringCreateWithCString(0, basename(fullpath), 
          CFStringGetSystemEncoding());
  len = CFStringGetLength(cfstr);
  ustr = malloc(len * sizeof(UniChar)); 
  CFStringGetCharacters(cfstr, CFRangeMake(0, len), ustr); 

  // If you can create an FSRef, the file already exists -> delete it.
  e = FSMakeFSRefUnicode(&path, len, ustr, CFStringGetSystemEncoding(), &file);
  if (e == noErr) FSDeleteObject(&file);

  e = FSCreateFileUnicode (&path, len, ustr, NULL, NULL, NULL, fss);  
  free(ustr); 

  if (e == noErr) return 1;
  else return 0;
}



/* Flip the image vertically. The flipped image will be returned in
 * newpx. Needed since Carbon has the origin in the upper left corner,
 * and OpenGL in the lower left corner.
 */
static void
v_flip(const unsigned char * px, int width, int height,
       int numcomponents, unsigned char * newpx)
{   
  // FIXME: We should really use QuickTime to do this (Altivec! :)).
  // For importing, it's straightforward, but I have no clue how to do
  // this for the export case. kyrah 20030210.
  int i;
  if (!newpx) return; 
  for (i = 0; i < height; i++) {
    memcpy (newpx + (i * width * numcomponents),
            px + (((height - i) - 1) * numcomponents * width),
            numcomponents * width);
  }
}
  

/* Convert the image data in px from ARGB to RGBA.
 * Needed since Mac OS X uses ARGB internally, but OpenGL expects RGBA.
 */
static void 
argb_to_rgba(uint32_t * px, int width, int height) 
{
  uint32_t i;

  // ARGB -> RGBA
  for(i = 0; i < (height * width); i++)
      *(px+i) = ((*(px+i) & 0x00FFFFFF ) << 8) | ((*(px+i) >> 24) & 0x000000FF);
}


/* Convert the image data in px from RGBA to ARGB.
 * Needed since Mac OS X uses ARGB internally, but OpenGL expects RGBA.
 */
static void 
rgba_to_argb(uint32_t * px, int width, int height) 
{
  uint32_t i;

  // RGBA -> ARGB
  for(i = 0; i < (height * width); i++)
      *(px+i) = ((*(px+i) & 0xFFFFFF00 ) >> 8) | ((*(px+i) << 24) & 0xFF000000);
}



// -------------------- public functions ---------------------------


int
simage_quicktime_error(char * cstr, int buflen)
{
  switch (quicktimeerror) {
  case ERR_OPEN:
    strncpy(cstr, "QuickTime loader: Error opening file", buflen);
    break;
  case ERR_CG:
    strncpy(cstr, "QuickTime loader: Internal graphics error", buflen);
    break;
  case ERR_WRITE:
    strncpy(cstr, "QuickTime saver: Error writing file", buflen);    
    break;
  case ERR_UNSUPPORTED:
    strncpy(cstr, "QuickTime saver: Unsupported file format", buflen);    
    break;
  case ERR_MEM:
    strncpy(cstr, "QuickTime loader/saver: Out of memory", buflen);    
    break;
  }
  return quicktimeerror;
}


int 
simage_quicktime_identify(const char * file, const unsigned char * header,
                          int headerlen)
{
  GraphicsImportComponent c;
  int ret = get_importer(file, &c);
  CloseComponent(c);
  return ret;
}


unsigned char *
simage_quicktime_load(const char * file, int * width,
                      int * height, int * numcomponents)
{
  GraphicsImportComponent gi;
  ImageDescriptionHandle desch = NULL;
  ImageDescription * desc;
  GWorldPtr gw;
  unsigned char * newpx = NULL;
  Rect r;
  BitmapInfo bi; 
  int e = noErr;

  if (!get_importer(file, &gi)) {
    quicktimeerror = ERR_OPEN;
    return NULL;
  }

  e = GraphicsImportGetImageDescription(gi, &desch);
  if(e != noErr || desch == NULL) {
    quicktimeerror = ERR_CG;
    return NULL;
  } 

  desc = *desch;
  bi.width = desc->width;
  bi.height = desc->height;
  bi.numcomponents = 4;
  bi.bitsPerPixel = 32;     // not 24!
  bi.bytesPerRow = (bi.bitsPerPixel * bi.width + 7)/8;
  bi.size = bi.width * bi.height * bi.numcomponents;
  bi.data = malloc(bi.size);
  if(bi.data == NULL) {
    quicktimeerror = ERR_MEM;
    return NULL;
  }

  r.top = 0;
  r.left = 0;
  r.bottom = bi.height;
  r.right = bi.width;

  NewGWorldFromPtr(&gw, k32ARGBPixelFormat, &r, NULL, 
                   NULL, 0, bi.data, bi.bytesPerRow);
  GraphicsImportSetGWorld(gi, gw, NULL);
  e = GraphicsImportDraw(gi);
  if (e != noErr) {
    quicktimeerror = ERR_CG;
    return NULL;
  }

  newpx = malloc(bi.width * bi.height * bi.numcomponents);
  v_flip(bi.data, bi.width, bi.height, bi.numcomponents, newpx);

#if 0 // QuickTime flip code for reference. See FIXME note at v_flip. 
  MatrixRecord mr;
  GraphicsImportGetMatrix(gi, &mr);
  ScaleMatrix(&mr, fixed1, Long2Fix(-1), 0, 0);
  TranslateMatrix(&mr, 0, Long2Fix(r.bottom));
  GraphicsImportSetMatrix(gi, &mr);
#endif

  argb_to_rgba((uint32_t *)newpx, bi.width, bi.height);

  DisposeHandle((Handle)desch);
  DisposeGWorld(gw); 
  CloseComponent(gi);

  *width = bi.width;
  *height = bi.height;
  *numcomponents = bi.numcomponents;
  return newpx;
}


char * 
simage_quicktime_get_savers(void)
{
  CFMutableStringRef ret = CFStringCreateMutable (NULL, 0);
  Component c = 0;
  bool firstext = true;
  char * cstr;
  OSType * ext = malloc(sizeof(OSType));

  // Search for all graphics exporters, except the base exporter.
  ComponentDescription cd;
  cd.componentType = GraphicsExporterComponentType;
  cd.componentSubType = 0;
  cd.componentManufacturer = 0;
  cd.componentFlags = 0;
  cd.componentFlagsMask = graphicsExporterIsBaseExporter;

  while ((c = FindNextComponent (c, &cd)) != 0) {
    // put '," in front of all consecutive string entries
    if (firstext) firstext = false;
    else CFStringAppendCString(ret, ",", CFStringGetSystemEncoding());
    GraphicsExportGetDefaultFileNameExtension((GraphicsExportComponent)c, ext);
    cfstring_append_ostype(ret, ext);
  }
  free(ext);
  cstr = malloc(CFStringGetLength(ret));
  strcpy(cstr, CFStringGetCStringPtr(ret, CFStringGetSystemEncoding()));
  return cstr;
}


int 
simage_quicktime_save(const char * filename, const unsigned char * px,
                       int width, int height, int numcomponents,
                       const char * filetypeext)
{
  GWorldPtr gw;
  FSSpec fss;
  GraphicsExportComponent ge;
  int e = noErr;
  Rect r = {0, 0, height, width};
  unsigned char * newpx = malloc(width * height * numcomponents);

  v_flip(px, width, height, numcomponents, newpx);
  rgba_to_argb((uint32_t *)newpx, width, height);

  e = NewGWorldFromPtr(&gw, k32ARGBPixelFormat, &r, NULL,
                       NULL, 0, newpx, width * numcomponents);
  if (e != noErr) {
    quicktimeerror = ERR_CG;
    return NULL;
  }

  if (!create_file(filename, &fss)) {
    quicktimeerror = ERR_WRITE;
    return 0;
  } 

  open_exporter(filetypeext, &ge);
  if (!ge) { 
    quicktimeerror = ERR_UNSUPPORTED;
    return 0;
  }

  GraphicsExportSetInputGWorld(ge, gw);
  GraphicsExportSetOutputFile(ge, &fss);
  e = GraphicsExportDoExport(ge, NULL);
  if (e != noErr) {
    quicktimeerror = ERR_WRITE;
    return 0;
  }
  CloseComponent(ge);

  return 1;
}

