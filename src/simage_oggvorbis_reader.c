#include <config.h>
#ifdef SIMAGE_OGGVORBIS_SUPPORT

#include <simage.h>
#include <simage_private.h>
#include <simage_oggvorbis.h>

#include <stdio.h>
#include <stdlib.h>

#include <vorbis/codec.h>
#include <vorbis/vorbisfile.h>

typedef struct {
  FILE *file;
  OggVorbis_File vorbisfile;
  int current_section;
} oggvorbis_reader_context;


static void 
oggvorbis_reader_init_context(oggvorbis_reader_context *context)
{
  context->file = NULL;
  context->current_section = 0;
}

static void 
oggvorbis_reader_cleanup_context(oggvorbis_reader_context *context)
{
}

static size_t 
oggvorbis_reader_read_cb(void *ptr, size_t size, size_t nmemb, 
                                void *datasource)
{
  oggvorbis_reader_context *context = (oggvorbis_reader_context *)datasource;
  return fread(ptr, size, nmemb, context->file);
}

static int 
oggvorbis_reader_seek_cb(void *datasource, ogg_int64_t offset, int whence)
{
  return -1; /* seek not supported */
}

static int 
oggvorbis_reader_close_cb(void *datasource)
{
  oggvorbis_reader_context *context = (oggvorbis_reader_context *)datasource;
  if (context->file != NULL)
    fclose(context->file);
  context->file = NULL;
  return 0;
}

static int 
oggvorbis_reader_open(oggvorbis_reader_context **contextp, 
                      const char *filename)
{
  ov_callbacks callbacks;
  oggvorbis_reader_context *context;  

  *contextp = (oggvorbis_reader_context *) 
    malloc(sizeof(oggvorbis_reader_context));
  oggvorbis_reader_init_context(*contextp);
  context = *contextp;  
  
  context->file = fopen(filename, "rb");
  if (context->file == NULL) {
    oggvorbis_reader_cleanup_context(context);
    free(context);
    return 0;
  }

  callbacks.read_func = oggvorbis_reader_read_cb;
  callbacks.seek_func = oggvorbis_reader_seek_cb;
  callbacks.close_func = oggvorbis_reader_close_cb;
  callbacks.tell_func = NULL;

  if(ov_open_callbacks((void *)context, &context->vorbisfile, NULL, 0, 
                       callbacks) < 0) {
    fclose(context->file);
    context->file = NULL;
    oggvorbis_reader_cleanup_context(context);
    free(context);
    return 0;
  }

  return 1;
}

static int 
oggvorbis_reader_read(oggvorbis_reader_context *context, 
                      char *buffer, int size)
{
  int readsize;
  int numread;

  readsize = 0;
  numread = 0;

  while (readsize<size) {
    numread=ov_read(&context->vorbisfile, 
                    buffer+readsize, 
                    size-readsize, 0, 2, 1, 
                    &context->current_section);
    if (numread<=0)
      return numread;
    else
      readsize += numread;
  }
  return readsize;
}

static void 
oggvorbis_reader_get_stream_info(oggvorbis_reader_context *context, 
                                 int *channels, int *samplerate)
{
  if (context->file) {
    vorbis_info * vi;
    vi = ov_info(&context->vorbisfile,-1);
    *channels = vi->channels;
    *samplerate = vi->rate;
  }
}


static void 
oggvorbis_reader_close(oggvorbis_reader_context *context)
{
  if (context->file != NULL)
    ov_clear(&context->vorbisfile);

  oggvorbis_reader_cleanup_context(context);
  free(context);
}


int 
oggvorbis_reader_stream_open(const char * filename, s_stream * stream,
                             s_params * params)
{
  oggvorbis_reader_context *context;
  int channels, samplerate;
  
  if (!oggvorbis_reader_open(&context, filename)) 
    return 0;

  s_stream_context_set(stream, (void *)context);

  oggvorbis_reader_get_stream_info(context, &channels, &samplerate);
  s_params_set(s_stream_params(stream), "channels", 
               S_INTEGER_PARAM_TYPE, channels, 0);
  s_params_set(s_stream_params(stream), "samplerate", 
               S_INTEGER_PARAM_TYPE, samplerate, 0);
  return 1;
}

void * 
oggvorbis_reader_stream_get(s_stream * stream, void * buffer, int * size, s_params * params)
{
  int ret;
  oggvorbis_reader_context *context;

  context = (oggvorbis_reader_context *)s_stream_context_get(stream);

  if (context != NULL) {
    ret = oggvorbis_reader_read(context, (char*) buffer, *size);
    if (ret>0) {
      *size = ret;
      return buffer;
    }
    /* fixme 20020904 thammer: check params for conversion requests
     */
  }
  *size=0;
  return NULL;
}

void 
oggvorbis_reader_stream_close(s_stream * stream)
{
  oggvorbis_reader_context *context;

  context = (oggvorbis_reader_context *)s_stream_context_get(stream);
  if (context != NULL) {
    oggvorbis_reader_close(context);
  }
}

#endif /* SIMAGE_OGGVORBIS_SUPPORT */
