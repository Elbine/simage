#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif /* HAVE_CONFIG_H */
#include <simage.h>
#include <string.h>

struct _loader_data
{
  struct simage_plugin funcs;
  struct _loader_data *next;
  int is_internal;
};

typedef struct _loader_data loader_data;

/* Note: if any more internal formats are added, please update the
   documentation on the "filename" field of Coin's SoTexture2 node in
   Coin/src/nodes/SoTexture2.cpp. */

/* built in image loaders */ 
#ifdef HAVE_JPEGLIB
#include <simage_jpeg.h>
static loader_data jpeg_loader;
#endif /* HAVE_JPEGLIB */
#ifdef HAVE_PNGLIB
#include <simage_png.h>
static loader_data png_loader;
#endif /* HAVE_PNGLIB */
#ifdef SIMAGE_TGA_SUPPORT
#include <simage_tga.h>
static loader_data targa_loader;
#endif /* SIMAGE_TGA_SUPPORT */
#ifdef HAVE_TIFFLIB
#include <simage_tiff.h>
static loader_data tiff_loader;
#endif /* HAVE_TIFFLIB */
#ifdef SIMAGE_PIC_SUPPORT
#include <simage_pic.h>
static loader_data pic_loader;
#endif /* SIMAGE_PIC_SUPPORT */
#ifdef SIMAGE_RGB_SUPPORT
#include <simage_rgb.h>
static loader_data rgb_loader;
#endif /* SIMAGE_PIC_SUPPORT */
#ifdef HAVE_UNGIFLIB
#include <simage_gif.h>
static loader_data gif_loader;
#endif /* HAVE_UNGIFLIB */
#ifdef SIMAGE_XWD_SUPPORT
#include <simage_xwd.h>
static loader_data xwd_loader;
#endif /* SIMAGE_XWD_SUPPORT */
#ifdef SIMAGE_QIMAGE_SUPPORT
#include <simage_qimage.h>
static loader_data qimage_loader;
#endif /* SIMAGE_QIMAGE_SUPPORT */
#ifdef SIMAGE_QUICKTIME_SUPPORT
#include <simage_quicktime.h>
static loader_data quicktime_loader;
#endif /* SIMAGE_QUICKTIME */

#include <assert.h>

static loader_data *first_loader = NULL;
static loader_data *last_loader = NULL;

/*
 * internal function which adds a loader to the list of loaders
 * returns a void pointer to the loader. addbefore specifies
 * if the loader should be added at the beginning or at the
 * end of the linked list. useful if a user program finds
 * a bug in this library (simply use addbefore) 
 */
static void *
add_loader(loader_data *loader,
	   unsigned char *(*load_func)(const char *,
				       int *,
				       int *,
				       int *),
	   int (*identify_func)(const char *,
				const unsigned char *,
				int headerlen),
	   int (*error_func)(char *, int),
	   int is_internal,
	   int addbefore)
{
  assert(loader);
  loader->funcs.load_func = load_func;
  loader->funcs.identify_func = identify_func;
  loader->funcs.error_func = error_func;
  loader->is_internal = is_internal;
  loader->next = NULL;

  if (first_loader == NULL) first_loader = last_loader = loader;
  else {
    if (addbefore) {
      loader->next = first_loader;
      first_loader = loader;
    }
    else {
      last_loader->next = loader;
      last_loader = loader;
    }
  }
  return (void*) loader;
}

/*
 * internal function which finds the correct loader. Returns
 * NULL if none was found
 */
static loader_data *
find_loader(const char *filename)
{
  loader_data *loader;
  int readlen;
  unsigned char buf[256] = {0};
  FILE *fp = fopen(filename, "rb");
  if (!fp) return NULL;

  readlen = fread(buf, 1, 256, fp);
  fclose(fp);
  if (readlen <= 0) return NULL;

  loader = first_loader;
  while (loader) {
    if (loader->funcs.identify_func(filename, buf, readlen)) break;
    loader = loader->next;
  }
  return loader;
}


static void
add_internal_loaders(void)
{
  static int first = 1;
  if (first) {
    first = 0;
#ifdef HAVE_JPEGLIB
    add_loader(&jpeg_loader, 
	       simage_jpeg_load,
	       simage_jpeg_identify,
	       simage_jpeg_error,
	       1, 0);
#endif /* HAVE_JPEGLIB */
#ifdef HAVE_PNGLIB
    add_loader(&png_loader, 
	       simage_png_load,
	       simage_png_identify,
	       simage_png_error,
	       1, 0);
#endif /* HAVE_PNGLIB */
#ifdef SIMAGE_TGA_SUPPORT
    add_loader(&targa_loader, 
	       simage_tga_load,
	       simage_tga_identify,
	       simage_tga_error,
	       1, 0);
#endif /* SIMAGE_TGA_SUPPORT */
#ifdef HAVE_TIFFLIB
    add_loader(&tiff_loader, 
	       simage_tiff_load,
	       simage_tiff_identify,
	       simage_tiff_error,
	       1, 0);
#endif /* HAVE_TIFFLIB */
#ifdef SIMAGE_RGB_SUPPORT
    add_loader(&rgb_loader, 
	       simage_rgb_load,
	       simage_rgb_identify,
	       simage_rgb_error,
	       1, 0);
#endif /* SIMAGE_RGB_SUPPORT */
#ifdef SIMAGE_PIC_SUPPORT
    add_loader(&pic_loader, 
	       simage_pic_load,
	       simage_pic_identify,
	       simage_pic_error,
	       1, 0);
#endif /* SIMAGE_PIC_SUPPORT */
#ifdef HAVE_UNGIFLIB
    add_loader(&gif_loader, 
               simage_gif_load,
               simage_gif_identify,
               simage_gif_error,
               1, 0);
#endif /* HAVE_UNGIFLIB */
#ifdef SIMAGE_XWD_SUPPORT
    add_loader(&xwd_loader,
               simage_xwd_load,
               simage_xwd_identify,
               simage_xwd_error,
               1, 0);
#endif /* SIMAGE_XWD_SUPPORT */
#ifdef SIMAGE_QIMAGE_SUPPORT
    add_loader(&qimage_loader,
               simage_qimage_load,
               simage_qimage_identify,
               simage_qimage_error,
               1, 0);
#endif /* SIMAGE_QIMAGE_SUPPORT */
#ifdef SIMAGE_QUICKTIME_SUPPORT
    add_loader(&quicktime_loader,
               simage_quicktime_load,
               simage_quicktime_identify,
               simage_quicktime_error,
               1, 
               1); // add_before -- if we can use QuickTime, makeitso
#endif /* SIMAGE_QUICKTIME_SUPPORT */
  }
}

#define SIMAGE_ERROR_BUFSIZE 512
char simage_error_msg[SIMAGE_ERROR_BUFSIZE+1];

unsigned char *
simage_read_image(const char *filename,
		   int *width, int *height,
		   int *numComponents)
{
  loader_data *loader;

  simage_error_msg[0] = 0; /* clear error msg */
  add_internal_loaders();  

  loader = find_loader(filename);

  if (loader) {
    unsigned char * data = 
      loader->funcs.load_func(filename, width,
                              height, numComponents);
    if (data == NULL) {
      (void) loader->funcs.error_func(simage_error_msg, SIMAGE_ERROR_BUFSIZE);
    }
    return data;
  }
  else {
    strcpy(simage_error_msg, "Unsupported image format.");
    return NULL;
  }
}

const char *
simage_get_last_error(void)
{
  return simage_error_msg;
}

void 
simage_clear_error(void);

int 
simage_check_supported(const char *filename)
{
  add_internal_loaders();
  return find_loader(filename) != NULL;
}

void *
simage_add_loader(const struct simage_plugin * plugin, int addbefore)
{
  add_internal_loaders();
  return add_loader((loader_data *)malloc(sizeof(loader_data)), 
		    plugin->load_func, 
		    plugin->identify_func,
		    plugin->error_func,
		    0, addbefore);
}

void 
simage_remove_loader(void * handle)
{
  loader_data *prev = NULL;
  loader_data *loader = first_loader;
  
  while (loader && loader != (loader_data*)handle) {
    prev = loader;
    loader = loader->next;
  }
  assert(loader);
  if (loader) { /* found it! */
    if (last_loader == loader) { /* new last_loader? */
      last_loader = prev;
    }
    if (prev) prev->next = loader->next;
    else first_loader = loader->next;
    if (loader) free(loader);
  }
}

/*
 * a helpful function
 */
static int 
cnt_bits(int val, int * highbit)
{
  int cnt = 0;
  *highbit = 0;
  while (val) {
    if (val & 1) cnt++;
    val>>=1;
    (*highbit)++;
  }
  return cnt;
}

int 
simage_next_power_of_two(int val)
{
  /* FIXME: this is done in a more elegant way in Coin's tidbits.c
     file. 20021210 mortene.*/

  int highbit;
  if (cnt_bits(val, &highbit) > 1) {
    return 1<<highbit;
  }
  return val;  
}

void
simage_version(int * major, int * minor, int * micro)
{
  if ( major != NULL ) *major = SIMAGE_MAJOR_VERSION;
  if ( minor != NULL ) *minor = SIMAGE_MINOR_VERSION;
  if ( micro != NULL ) *micro = SIMAGE_MICRO_VERSION;
}

void
simage_free_image(unsigned char * imagedata)
{
  if (imagedata) free(imagedata);
}
