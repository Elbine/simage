#include <config.h>
#ifdef SIMAGE_AVIENC_SUPPORT

#include <simage_private.h>
#include <simage_avi.h>

#include <stdio.h>

int 
avienc_movie_create(const char * filename, s_movie * movie, s_params * params)
{
  void * handle;

  int width;
  int height;
  int fps;
  const char *preferences_filename;

  width = height = fps = 0;
  preferences_filename = NULL;

  s_params_get(params, 
               "parameter file", S_STRING_PARAM_TYPE, &preferences_filename, NULL);

  s_params_get(params,
               "width", S_INTEGER_PARAM_TYPE, &width, NULL);
  
  s_params_get(params,
              "height", S_INTEGER_PARAM_TYPE, &height, NULL);

  s_params_get(params,
               "fps", S_INTEGER_PARAM_TYPE, &fps, NULL);

  /*
  if preferences_filename == NULL or a file named preferences_filename does not exist,
    a GUI dialog box will pop up and ask for preferences (compression method and parameters)
    if preferences_filename != NULL and user didn't press [Cancel]
      preferences will be saved to a new file named preferences_filename
  else (a file named preferences_filename exists)
    the preferences will be read from the specified file and no GUI will pop up

  */

  handle = (void *)avi_begin_encode(filename, width, height, fps, preferences_filename);
  
  if (handle == NULL) return 0;
  
  s_params_set(s_movie_params(movie), "avienc handle", S_POINTER_PARAM_TYPE, handle, 0);
  return 1;
}

int 
avienc_movie_put(s_movie * movie, s_image * image, s_params * params)
{
  void * handle;

  if (s_params_get(s_movie_params(movie), "avienc handle", S_POINTER_PARAM_TYPE, &handle, 0)) {
    return avi_encode_bitmap(handle, s_image_data(image), 1);
  }
  return 0;
}

void 
avienc_movie_close(s_movie * movie)
{
  void * handle;
  if (s_params_get(s_movie_params(movie), "avienc handle", S_POINTER_PARAM_TYPE, &handle, 0)) {
    avi_end_encode(handle);
  }
}

#endif /* SIMAGE_AVIENC_SUPPORT */