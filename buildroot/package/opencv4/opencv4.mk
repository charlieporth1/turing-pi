################################################################################
#
# opencv4
#
################################################################################

OPENCV4_VERSION = 4.5.5
OPENCV4_SITE = $(call github,opencv,opencv,$(OPENCV4_VERSION))
OPENCV4_INSTALL_STAGING = YES
OPENCV4_LICENSE = Apache-2.0
OPENCV4_LICENSE_FILES = LICENSE
OPENCV4_CPE_ID_VENDOR = opencv
OPENCV4_CPE_ID_PRODUCT = opencv
OPENCV4_SUPPORTS_IN_SOURCE_BUILD = NO

OPENCV4_CXXFLAGS = $(TARGET_CXXFLAGS)

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
OPENCV4_CXXFLAGS += -latomic
endif

# Fix c++11 build with missing std::exception_ptr
ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_64735),y)
OPENCV4_CXXFLAGS += -DCV__EXCEPTION_PTR=0
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
OPENCV4_CXXFLAGS += -O0
endif

# OpenCV component options
OPENCV4_CONF_OPTS += \
	-DCMAKE_CXX_FLAGS="$(OPENCV4_CXXFLAGS)" \
	-DBUILD_DOCS=OFF \
	-DBUILD_PERF_TESTS=$(if $(BR2_PACKAGE_OPENCV4_BUILD_PERF_TESTS),ON,OFF) \
	-DBUILD_TESTS=$(if $(BR2_PACKAGE_OPENCV4_BUILD_TESTS),ON,OFF) \
	-DBUILD_WITH_DEBUG_INFO=OFF \
	-DDOWNLOAD_EXTERNAL_TEST_DATA=OFF \
	-DOPENCV_GENERATE_PKGCONFIG=ON \
	-DOPENCV_ENABLE_PKG_CONFIG=ON

ifeq ($(BR2_PACKAGE_OPENCV4_BUILD_TESTS)$(BR2_PACKAGE_OPENCV4_BUILD_PERF_TESTS),)
OPENCV4_CONF_OPTS += -DINSTALL_TEST=OFF
else
OPENCV4_CONF_OPTS += -DINSTALL_TEST=ON
endif

# OpenCV build options
OPENCV4_CONF_OPTS += \
	-DBUILD_WITH_STATIC_CRT=OFF \
	-DENABLE_CCACHE=OFF \
	-DENABLE_COVERAGE=OFF \
	-DENABLE_FAST_MATH=ON \
	-DENABLE_IMPL_COLLECTION=OFF \
	-DENABLE_NOISY_WARNINGS=OFF \
	-DENABLE_OMIT_FRAME_POINTER=ON \
	-DENABLE_PRECOMPILED_HEADERS=OFF \
	-DENABLE_PROFILING=OFF \
	-DOPENCV_WARNINGS_ARE_ERRORS=OFF

# OpenCV link options
OPENCV4_CONF_OPTS += \
	-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF \
	-DCMAKE_SKIP_RPATH=OFF \
	-DCMAKE_USE_RELATIVE_PATHS=OFF

# OpenCV packaging options:
OPENCV4_CONF_OPTS += \
	-DBUILD_PACKAGE=OFF \
	-DENABLE_SOLUTION_FOLDERS=OFF \
	-DINSTALL_CREATE_DISTRIB=OFF

# OpenCV module selection
# * Modules on:
#   - core: if not set, opencv does not build anything
#   - hal: core's dependency
# * Modules off:
#   - android*: android stuff
#   - apps: programs for training classifiers
#   - java: java bindings
#   - viz: missing VTK dependency
#   - world: all-in-one module
#
# * Contrib modules from [1] are disabled:
#   - opencv_contrib package is not available in Buildroot;
#   - OPENCV_EXTRA_MODULES_PATH is not set.
#
# [1] https://github.com/Itseez/opencv_contrib
OPENCV4_CONF_OPTS += \
	-DBUILD_opencv_androidcamera=OFF \
	-DBUILD_opencv_apps=OFF \
	-DBUILD_opencv_calib3d=$(if $(BR2_PACKAGE_OPENCV4_LIB_CALIB3D),ON,OFF) \
	-DBUILD_opencv_core=ON \
	-DBUILD_opencv_features2d=$(if $(BR2_PACKAGE_OPENCV4_LIB_FEATURES2D),ON,OFF) \
	-DBUILD_opencv_flann=$(if $(BR2_PACKAGE_OPENCV4_LIB_FLANN),ON,OFF) \
	-DBUILD_opencv_highgui=$(if $(BR2_PACKAGE_OPENCV4_LIB_HIGHGUI),ON,OFF) \
	-DBUILD_opencv_imgcodecs=$(if $(BR2_PACKAGE_OPENCV4_LIB_IMGCODECS),ON,OFF) \
	-DBUILD_opencv_imgproc=$(if $(BR2_PACKAGE_OPENCV4_LIB_IMGPROC),ON,OFF) \
	-DBUILD_opencv_java=OFF \
	-DBUILD_opencv_ml=$(if $(BR2_PACKAGE_OPENCV4_LIB_ML),ON,OFF) \
	-DBUILD_opencv_objdetect=$(if $(BR2_PACKAGE_OPENCV4_LIB_OBJDETECT),ON,OFF) \
	-DBUILD_opencv_photo=$(if $(BR2_PACKAGE_OPENCV4_LIB_PHOTO),ON,OFF) \
	-DBUILD_opencv_shape=$(if $(BR2_PACKAGE_OPENCV4_LIB_SHAPE),ON,OFF) \
	-DBUILD_opencv_stitching=$(if $(BR2_PACKAGE_OPENCV4_LIB_STITCHING),ON,OFF) \
	-DBUILD_opencv_superres=$(if $(BR2_PACKAGE_OPENCV4_LIB_SUPERRES),ON,OFF) \
	-DBUILD_opencv_ts=$(if $(BR2_PACKAGE_OPENCV4_LIB_TS),ON,OFF) \
	-DBUILD_opencv_video=$(if $(BR2_PACKAGE_OPENCV4_LIB_VIDEO),ON,OFF) \
	-DBUILD_opencv_videoio=$(if $(BR2_PACKAGE_OPENCV4_LIB_VIDEOIO),ON,OFF) \
	-DBUILD_opencv_videostab=$(if $(BR2_PACKAGE_OPENCV4_LIB_VIDEOSTAB),ON,OFF) \
	-DBUILD_opencv_viz=OFF \
	-DBUILD_opencv_world=OFF

# Hardware support options.
#
# * PowerPC and VFPv3 support are turned off since their only effects
#   are altering CFLAGS, adding '-mcpu=G3 -mtune=G5' or '-mfpu=vfpv3'
#   to them, which is already handled by Buildroot.
# * NEON logic is needed as it is not only used to add CFLAGS, but
#   also to enable additional NEON code.
OPENCV4_CONF_OPTS += \
	-DENABLE_POWERPC=OFF \
	-DENABLE_NEON=$(if $(BR2_ARM_CPU_HAS_NEON),ON,OFF) \
	-DENABLE_VFPV3=OFF

# Cuda stuff
OPENCV4_CONF_OPTS += \
	-DBUILD_CUDA_STUBS=OFF \
	-DBUILD_opencv_cudaarithm=OFF \
	-DBUILD_opencv_cudabgsegm=OFF \
	-DBUILD_opencv_cudacodec=OFF \
	-DBUILD_opencv_cudafeatures2d=OFF \
	-DBUILD_opencv_cudafilters=OFF \
	-DBUILD_opencv_cudaimgproc=OFF \
	-DBUILD_opencv_cudalegacy=OFF \
	-DBUILD_opencv_cudaobjdetect=OFF \
	-DBUILD_opencv_cudaoptflow=OFF \
	-DBUILD_opencv_cudastereo=OFF \
	-DBUILD_opencv_cudawarping=OFF \
	-DBUILD_opencv_cudev=OFF \
	-DWITH_CUBLAS=OFF \
	-DWITH_CUDA=OFF \
	-DWITH_CUFFT=OFF

# NVidia stuff
OPENCV4_CONF_OPTS += -DWITH_NVCUVID=OFF

# AMD stuff
OPENCV4_CONF_OPTS += \
	-DWITH_OPENCLAMDBLAS=OFF \
	-DWITH_OPENCLAMDFFT=OFF

# Intel stuff
OPENCV4_CONF_OPTS += \
	-DBUILD_WITH_DYNAMIC_IPP=OFF \
	-DWITH_INTELPERC=OFF \
	-DWITH_IPP=OFF \
	-DWITH_IPP_A=OFF \
	-DWITH_TBB=OFF

# Smartek stuff
OPENCV4_CONF_OPTS += -DWITH_GIGEAPI=OFF

# Prosilica stuff
OPENCV4_CONF_OPTS += -DWITH_PVAPI=OFF

# Ximea stuff
OPENCV4_CONF_OPTS += -DWITH_XIMEA=OFF

# Non-Linux support (Android options) must remain OFF:
OPENCV4_CONF_OPTS += \
	-DANDROID=OFF \
	-DBUILD_ANDROID_CAMERA_WRAPPER=OFF \
	-DBUILD_ANDROID_EXAMPLES=OFF \
	-DBUILD_ANDROID_SERVICE=OFF \
	-DBUILD_FAT_JAVA_LIB=OFF \
	-DINSTALL_ANDROID_EXAMPLES=OFF \
	-DWITH_ANDROID_CAMERA=OFF

# Non-Linux support (Mac OSX options) must remain OFF:
OPENCV4_CONF_OPTS += \
	-DWITH_AVFOUNDATION=OFF \
	-DWITH_CARBON=OFF \
	-DWITH_QUICKTIME=OFF

# Non-Linux support (Windows options) must remain OFF:
OPENCV4_CONF_OPTS += \
	-DWITH_CSTRIPES=OFF \
	-DWITH_DSHOW=OFF \
	-DWITH_MSMF=OFF \
	-DWITH_VFW=OFF \
	-DWITH_VIDEOINPUT=OFF \
	-DWITH_WIN32UI=OFF

# Software/3rd-party support options:
# - disable all examples
OPENCV4_CONF_OPTS += \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_JASPER=OFF \
	-DBUILD_JPEG=OFF \
	-DBUILD_OPENEXR=OFF \
	-DBUILD_OPENJPEG=OFF \
	-DBUILD_PNG=OFF \
	-DBUILD_PROTOBUF=OFF \
	-DBUILD_TIFF=OFF \
	-DBUILD_ZLIB=OFF \
	-DINSTALL_C_EXAMPLES=OFF \
	-DINSTALL_PYTHON_EXAMPLES=OFF \
	-DINSTALL_TO_MANGLED_PATHS=OFF

# Disabled features (mostly because they are not available in Buildroot), but
# - eigen: OpenCV does not use it, not take any benefit from it.
OPENCV4_CONF_OPTS += \
	-DWITH_1394=OFF \
	-DWITH_CLP=OFF \
	-DWITH_EIGEN=OFF \
	-DWITH_GDAL=OFF \
	-DWITH_GPHOTO2=OFF \
	-DWITH_GSTREAMER_0_10=OFF \
	-DWITH_LAPACK=OFF \
	-DWITH_MATLAB=OFF \
	-DWITH_OPENCL=OFF \
	-DWITH_OPENCL_SVM=OFF \
	-DWITH_OPENEXR=OFF \
	-DWITH_OPENNI2=OFF \
	-DWITH_OPENNI=OFF \
	-DWITH_UNICAP=OFF \
	-DWITH_VA=OFF \
	-DWITH_VA_INTEL=OFF \
	-DWITH_VTK=OFF \
	-DWITH_XINE=OFF

OPENCV4_DEPENDENCIES += host-pkgconf zlib

ifeq ($(BR2_PACKAGE_OPENCV4_JPEG2000_WITH_JASPER),y)
OPENCV4_CONF_OPTS += -DWITH_JASPER=ON
OPENCV4_DEPENDENCIES += jasper
else
OPENCV4_CONF_OPTS += -DWITH_JASPER=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_JPEG2000_WITH_OPENJPEG),y)
OPENCV4_CONF_OPTS += -DWITH_OPENJPEG=ON
OPENCV4_DEPENDENCIES += openjpeg
else
OPENCV4_CONF_OPTS += -DWITH_OPENJPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_FFMPEG),y)
OPENCV4_CONF_OPTS += -DWITH_FFMPEG=ON
OPENCV4_DEPENDENCIES += ffmpeg bzip2
else
OPENCV4_CONF_OPTS += -DWITH_FFMPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_GSTREAMER1),y)
OPENCV4_CONF_OPTS += -DWITH_GSTREAMER=ON
OPENCV4_DEPENDENCIES += gstreamer1 gst1-plugins-base
else
OPENCV4_CONF_OPTS += -DWITH_GSTREAMER=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_GTK)$(BR2_PACKAGE_OPENCV4_WITH_GTK3),)
OPENCV4_CONF_OPTS += -DWITH_GTK=OFF -DWITH_GTK_2_X=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_GTK),y)
OPENCV4_CONF_OPTS += -DWITH_GTK=ON -DWITH_GTK_2_X=ON
OPENCV4_DEPENDENCIES += libgtk2
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_GTK3),y)
OPENCV4_CONF_OPTS += -DWITH_GTK=ON -DWITH_GTK_2_X=OFF
OPENCV4_DEPENDENCIES += libgtk3
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_JPEG),y)
OPENCV4_CONF_OPTS += -DWITH_JPEG=ON
OPENCV4_DEPENDENCIES += jpeg
else
OPENCV4_CONF_OPTS += -DWITH_JPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_OPENGL),y)
OPENCV4_CONF_OPTS += -DWITH_OPENGL=ON
OPENCV4_DEPENDENCIES += libgl
else
OPENCV4_CONF_OPTS += -DWITH_OPENGL=OFF
endif

OPENCV4_CONF_OPTS += -DWITH_OPENMP=$(if $(BR2_TOOLCHAIN_HAS_OPENMP),ON,OFF)

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_PNG),y)
OPENCV4_CONF_OPTS += -DWITH_PNG=ON
OPENCV4_DEPENDENCIES += libpng
else
OPENCV4_CONF_OPTS += -DWITH_PNG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_PROTOBUF),y)
OPENCV4_CONF_OPTS += \
	-DPROTOBUF_UPDATE_FILES=ON \
	-DWITH_PROTOBUF=ON
OPENCV4_DEPENDENCIES += protobuf
else
OPENCV4_CONF_OPTS += -DWITH_PROTOBUF=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_QT5),y)
OPENCV4_CONF_OPTS += -DWITH_QT=5
OPENCV4_DEPENDENCIES += qt5base
else
OPENCV4_CONF_OPTS += -DWITH_QT=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_TIFF),y)
OPENCV4_CONF_OPTS += -DWITH_TIFF=ON
OPENCV4_DEPENDENCIES += tiff
else
OPENCV4_CONF_OPTS += -DWITH_TIFF=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_V4L),y)
OPENCV4_CONF_OPTS += \
	-DWITH_LIBV4L=$(if $(BR2_PACKAGE_LIBV4L),ON,OFF) \
	-DWITH_V4L=ON
OPENCV4_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBV4L),libv4l)
else
OPENCV4_CONF_OPTS += -DWITH_V4L=OFF -DWITH_LIBV4L=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_WITH_WEBP),y)
OPENCV4_CONF_OPTS += -DWITH_WEBP=ON
OPENCV4_DEPENDENCIES += webp
else
OPENCV4_CONF_OPTS += -DWITH_WEBP=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV4_LIB_PYTHON),y)
OPENCV4_CONF_OPTS += \
	-DBUILD_opencv_python2=OFF \
	-DBUILD_opencv_python3=ON \
	-DPYTHON3_EXECUTABLE=$(HOST_DIR)/bin/python3 \
	-DPYTHON3_INCLUDE_PATH=$(STAGING_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR) \
	-DPYTHON3_LIBRARIES=$(STAGING_DIR)/usr/lib/libpython$(PYTHON3_VERSION_MAJOR).so \
	-DPYTHON3_NUMPY_INCLUDE_DIRS=$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/numpy/core/include \
	-DPYTHON3_PACKAGES_PATH=/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages \
	-DPYTHON3_NUMPY_VERSION=$(PYTHON_NUMPY_VERSION)
OPENCV4_DEPENDENCIES += python3
OPENCV4_KEEP_PY_FILES += usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/cv2/config*.py
OPENCV4_CONF_ENV += $(PKG_PYTHON_DISTUTILS_ENV)
OPENCV4_DEPENDENCIES += python-numpy
else
OPENCV4_CONF_OPTS += \
	-DBUILD_opencv_python2=OFF \
	-DBUILD_opencv_python3=OFF
endif

# Installation hooks:
define OPENCV4_CLEAN_INSTALL_LICENSE
	$(RM) -fr $(TARGET_DIR)/usr/share/licenses/opencv4
endef
OPENCV4_POST_INSTALL_TARGET_HOOKS += OPENCV4_CLEAN_INSTALL_LICENSE

define OPENCV4_CLEAN_INSTALL_VALGRIND
	$(RM) -f $(TARGET_DIR)/usr/share/opencv4/valgrind*
endef
OPENCV4_POST_INSTALL_TARGET_HOOKS += OPENCV4_CLEAN_INSTALL_VALGRIND

ifneq ($(BR2_PACKAGE_OPENCV4_INSTALL_DATA),y)
define OPENCV4_CLEAN_INSTALL_DATA
	$(RM) -fr $(TARGET_DIR)/usr/share/opencv4/haarcascades \
		$(TARGET_DIR)/usr/share/opencv4/lbpcascades
endef
OPENCV4_POST_INSTALL_TARGET_HOOKS += OPENCV4_CLEAN_INSTALL_DATA
endif

$(eval $(cmake-package))
