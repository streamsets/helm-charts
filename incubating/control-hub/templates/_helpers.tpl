{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "control-hub.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "control-hub.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "control-hub.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mysql.fullname" -}}
{{- printf "%s-%s" .Release.Name "mysql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "influxdb.fullname" -}}
{{- printf "%s-%s" .Release.Name "influxdb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
For minikube support, we expect you to use the domain minikube.local and
set up a few workaounds for lack of LoadBalancer support.
*/}}
{{- define "externalPort" }}
{{- if (and (and (eq .Values.ingress.domain "minikube.local") (eq .Values.ingress.proto "http")) .Values.istio.enabled) }}
{{- printf ":31380" -}}
{{- else if (and (and (eq .Values.ingress.domain "minikube.local") (eq .Values.ingress.proto "https")) .Values.istio.enabled) }}
{{- printf ":31390" -}}
{{- end }}
{{- end }}
