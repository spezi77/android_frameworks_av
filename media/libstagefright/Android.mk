LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

include frameworks/av/media/libstagefright/codecs/common/Config.mk

LOCAL_SRC_FILES:=                         \
        ACodec.cpp                        \
        AACExtractor.cpp                  \
        AACWriter.cpp                     \
        AMRExtractor.cpp                  \
        AMRWriter.cpp                     \
        AudioPlayer.cpp                   \
        AudioSource.cpp                   \
        AwesomePlayer.cpp                 \
        CameraSource.cpp                  \
        CameraSourceTimeLapse.cpp         \
        ClockEstimator.cpp                \
        CodecBase.cpp                     \
        DataSource.cpp                    \
        DataURISource.cpp                 \
        DRMExtractor.cpp                  \
        ESDS.cpp                          \
        FileSource.cpp                    \
        FLACExtractor.cpp                 \
        HTTPBase.cpp                      \
        JPEGSource.cpp                    \
        MP3Extractor.cpp                  \
        MPEG2TSWriter.cpp                 \
        MPEG4Extractor.cpp                \
        MPEG4Writer.cpp                   \
        MediaAdapter.cpp                  \
        MediaBuffer.cpp                   \
        MediaBufferGroup.cpp              \
        MediaCodec.cpp                    \
        MediaCodecList.cpp                \
        MediaCodecSource.cpp              \
        MediaDefs.cpp                     \
        MediaExtractor.cpp                \
        http/MediaHTTP.cpp                \
        MediaMuxer.cpp                    \
        MediaSource.cpp                   \
        MetaData.cpp                      \
        NuCachedSource2.cpp               \
        NuMediaExtractor.cpp              \
        OMXClient.cpp                     \
        OMXCodec.cpp                      \
        OggExtractor.cpp                  \
        SampleIterator.cpp                \
        SampleTable.cpp                   \
        SkipCutBuffer.cpp                 \
        StagefrightMediaScanner.cpp       \
        StagefrightMetadataRetriever.cpp  \
        SurfaceMediaSource.cpp            \
        ThrottledSource.cpp               \
        TimeSource.cpp                    \
        TimedEventQueue.cpp               \
        Utils.cpp                         \
        VBRISeeker.cpp                    \
        WAVExtractor.cpp                  \
        WVMExtractor.cpp                  \
        XINGSeeker.cpp                    \
        avc_utils.cpp                     \

LOCAL_C_INCLUDES:= \
        $(TOP)/frameworks/av/include/media/ \
        $(TOP)/frameworks/av/include/media/stagefright/timedtext \
        $(TOP)/frameworks/native/include/media/hardware \
        $(TOP)/frameworks/native/include/media/openmax \
        $(TOP)/external/flac/include \
        $(TOP)/external/tremolo \
        $(TOP)/external/openssl/include \
        $(TOP)/external/libvpx/libwebm \
        $(TOP)/system/netd/include \
        $(TOP)/external/icu/icu4c/source/common \
        $(TOP)/external/icu/icu4c/source/i18n \

ifneq ($(TI_CUSTOM_DOMX_PATH),)
LOCAL_C_INCLUDES += $(TI_CUSTOM_DOMX_PATH)/omx_core/inc
LOCAL_CPPFLAGS += -DUSE_TI_CUSTOM_DOMX
else
LOCAL_C_INCLUDES += $(TOP)/frameworks/native/include/media/openmax
endif

ifneq ($(filter caf bfam,$(TARGET_QCOM_AUDIO_VARIANT)),)
    ifeq ($(BOARD_USES_LEGACY_ALSA_AUDIO),true)
        ifeq ($(call is-chipset-in-board-platform,msm8960),true)
            LOCAL_SRC_FILES += LPAPlayerALSA.cpp TunnelPlayer.cpp
            LOCAL_CFLAGS += -DUSE_TUNNEL_MODE
            LOCAL_CFLAGS += -DTUNNEL_MODE_SUPPORTS_AMRWB
        endif
        ifeq ($(call is-chipset-in-board-platform,msm8974),true)
            # If you are using legacy mode on 8974, you will not
            # go to space today. Also, it probably is broken.
            LOCAL_SRC_FILES += LPAPlayerALSA.cpp TunnelPlayer.cpp
            LOCAL_CFLAGS += -DUSE_TUNNEL_MODE
        endif
        ifneq ($(filter msm8660 msm7x30 msm7x27a,$(TARGET_BOARD_PLATFORM)),)
            LOCAL_SRC_FILES += LPAPlayer.cpp
            LOCAL_CFLAGS += -DLEGACY_LPA
        endif
        ifeq ($(NO_TUNNEL_MODE_FOR_MULTICHANNEL),true)
            LOCAL_CFLAGS += -DNO_TUNNEL_MODE_FOR_MULTICHANNEL
        endif
        LOCAL_SHARED_LIBRARIES += libstagefright_mp3dec
    endif
endif

ifneq ($(TARGET_QCOM_MEDIA_VARIANT),)
LOCAL_C_INCLUDES += \
        $(TOP)/hardware/qcom/media-$(TARGET_QCOM_MEDIA_VARIANT)/mm-core/inc
ifneq ($(TARGET_QCOM_MEDIA_VARIANT),caf-new)
    LOCAL_CFLAGS += -DLEGACY_MEDIA
endif
else
LOCAL_C_INCLUDES += \
        $(TOP)/hardware/qcom/media/mm-core/inc
endif

LOCAL_SHARED_LIBRARIES := \
        libbinder \
        libcamera_client \
        libcutils \
        libdl \
        libdrmframework \
        libexpat \
        libgui \
        libicui18n \
        libicuuc \
        liblog \
        libmedia \
        libnetd_client \
        libopus \
        libsonivox \
        libssl \
        libstagefright_omx \
        libstagefright_yuv \
        libsync \
        libui \
        libutils \
        libvorbisidec \
        libz \
        libpowermanager

LOCAL_STATIC_LIBRARIES := \
        libstagefright_color_conversion \
        libstagefright_aacenc \
        libstagefright_matroska \
        libstagefright_webm \
        libstagefright_timedtext \
        libvpx \
        libwebm \
        libstagefright_mpeg2ts \
        libstagefright_id3 \
        libFLAC \
        libmedia_helper

ifeq ($(call is-vendor-board-platform,QCOM),true)

ifeq ($(TARGET_USES_QCOM_BSP), true)
    LOCAL_C_INCLUDES += $(call project-path-for,qcom-display)/libgralloc
endif

ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS),true)
    LOCAL_CFLAGS     += -DENABLE_AV_ENHANCEMENTS
    LOCAL_SRC_FILES  += ExtendedMediaDefs.cpp ExtendedPrefetchSource.cpp ExtendedWriter.cpp
    LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
    LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

    ifneq ($(TARGET_QCOM_MEDIA_VARIANT),)
        LOCAL_C_INCLUDES += \
            $(TOP)/hardware/qcom/media-$(TARGET_QCOM_MEDIA_VARIANT)/mm-core/inc
    else
        LOCAL_C_INCLUDES += \
            $(TOP)/hardware/qcom/media/mm-core/inc
    endif

else #TARGET_ENABLE_AV_ENHANCEMENTS
ifeq ($(TARGET_ENABLE_OFFLOAD_ENHANCEMENTS),true)
    LOCAL_CFLAGS += -DENABLE_OFFLOAD_ENHANCEMENTS
endif

ifeq ($(TARGET_QCOM_LEGACY_OMX),true)
    LOCAL_CFLAGS += -DQCOM_LEGACY_OMX
endif

endif
endif

LOCAL_SHARED_LIBRARIES += \
        libstagefright_enc_common \
        libstagefright_avc_common \
        libstagefright_foundation \
        libdl

LOCAL_CFLAGS += -Wno-multichar

ifeq ($(BOARD_CANT_REALLOCATE_OMX_BUFFERS),true)
LOCAL_CFLAGS += -DBOARD_CANT_REALLOCATE_OMX_BUFFERS
endif

ifeq ($(BOARD_USES_LEGACY_ACQUIRE_WVM),true)
LOCAL_CFLAGS += -DUSES_LEGACY_ACQUIRE_WVM
endif

LOCAL_MODULE:= libstagefright

LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

include $(call all-makefiles-under,$(LOCAL_PATH))
