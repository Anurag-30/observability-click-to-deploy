include ../crd.Makefile
include ../gcloud.Makefile
include ../var.Makefile
include ../images.Makefile

CHART_NAME := elastic-gke-logging
APP_ID ?= $(CHART_NAME)
VERIFY_WAIT_TIMEOUT = 1200

TRACK ?= 7.10

KIBANA_TAG ?= 7.10
FLUENTD_TAG ?= 1.13
METRICS_EXPORTER_TAG ?= v0.5.1

SOURCE_REGISTRY ?= marketplace.gcr.io/google
IMAGE_ELASTICSEARCH ?= $(SOURCE_REGISTRY)/elasticsearch7:$(TRACK)
IMAGE_KIBANA ?= $(SOURCE_REGISTRY)/kibana7:$(KIBANA_TAG)
IMAGE_FLUENTD ?= $(SOURCE_REGISTRY)/fluentd1:$(FLUENTD_TAG)
IMAGE_UBUNTU16_04 ?= $(SOURCE_REGISTRY)/ubuntu1604:latest
IMAGE_PROMETHEUS_TO_SD ?= k8s.gcr.io/prometheus-to-sd:$(METRICS_EXPORTER_TAG)


# Main image
image-$(CHART_NAME) := $(call get_sha256,$(IMAGE_ELASTICSEARCH))

# List of images used in application
ADDITIONAL_IMAGES := kibana fluentd ubuntu16_04 prometheus-to-sd

# Additional images variable names should correspond with ADDITIONAL_IMAGES list
image-kibana :=  $(call get_sha256,$(IMAGE_KIBANA))
image-fluentd :=  $(call get_sha256,$(IMAGE_FLUENTD))
image-ubuntu16_04 :=  $(call get_sha256,$(IMAGE_UBUNTU16_04))
image-prometheus-to-sd := $(call get_sha256,$(IMAGE_PROMETHEUS_TO_SD))

C2D_CONTAINER_RELEASE := $(call get_c2d_release,$(image-$(CHART_NAME)))

BUILD_ID := $(shell date --utc +%Y%m%d-%H%M%S)
RELEASE ?= $(C2D_CONTAINER_RELEASE)-$(BUILD_ID)
NAME ?= $(APP_ID)-1
VERIFY_WAIT_TIMEOUT := 400

# Additional variables
ifdef ELASTICSEARCH_REPLICAS
  ELASTICSEARCH_REPLICAS_FIELD = , "elasticsearch.replicas": "$(ELASTICSEARCH_REPLICAS)"
endif

ifdef METRICS_EXPORTER_ENABLED
  METRICS_EXPORTER_ENABLED_FIELD = , "metrics.exporter.enabled": $(METRICS_EXPORTER_ENABLED)
endif

APP_PARAMETERS ?= { \
  "name": "$(NAME)", \
  "namespace": "$(NAMESPACE)" \
  $(ELASTICSEARCH_REPLICAS_FIELD) \
  $(METRICS_EXPORTER_ENABLED_FIELD) \
}

# c2d_deployer.Makefile provides the main targets for installing the application.
# It requires several APP_* variables defined above, and thus must be included after.
include ../c2d_deployer.Makefile


# Build tester image
app/build:: .build/$(CHART_NAME)/tester
