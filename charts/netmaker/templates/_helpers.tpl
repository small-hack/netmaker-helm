{{/*
Expand the name of the chart.
*/}}
{{- define "netmaker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "netmaker.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{/*
create image repo and tag based on appVersion and values input
*/}}
{{- define "netmaker.image" -}}
{{- if .Values.image.tag -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository .Chart.AppVersion -}}
{{- end -}}
{{- end }}

{{- define "netmaker.ui.image" -}}
{{- if .Values.image.tag -}}
{{- printf "gravitl/netmaker-ui:%s" .Values.image.tag -}}
{{- else -}}
{{- printf "gravitl/netmaker-ui:%s" .Chart.AppVersion -}}
{{- end -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "netmaker.masterKey" -}}
{{- randAlphaNum 12 | nospace -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "netmaker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "netmaker.labels" -}}
helm.sh/chart: {{ include "netmaker.chart" . }}
{{ include "netmaker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "netmaker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netmaker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "netmaker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "netmaker.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Username for postgresql
*/}}
{{- define "netmaker.database.username" -}}
{{- if .Values.postgresql.enabled }}
{{- index .Values "postgresql" "auth" "username" }}
{{- else }}
{{- index .Values "externalDatabase" "username" }}
{{- end }}
{{- end }}

{{/*
Password for postgresql
*/}}
{{- define "netmaker.database.password" -}}
{{- if .Values.postgresql.enabled }}
{{- if .Values.postgresql.auth.password }}
{{- index .Values "postgresql" "auth" "password" }}
{{- end }}
{{- else }}
{{- index .Values "externalDatabase" "password" }}
{{- end }}
{{- end }}

{{/*
Host for postgresql
*/}}
{{- define "netmaker.database.host" -}}
{{- if .Values.postgresql.enabled }}
{{ .Release.Name }}-postgresql.{{ .Release.Namespace }}
{{- else }}
{{- index .Values "externalDatabase" "host" }}
{{- end }}
{{- end }}

{{/*
Port for postgresql
*/}}
{{- define "netmaker.database.port" -}}
{{- if .Values.postgresql.enabled }}
{{- index .Values "postgresql" "containerPorts" "postgresql" }}
{{- else }}
{{- index .Values "externalDatabase" "port" }}
{{- end }}
{{- end }}

{{/*
Database for postgresql
*/}}
{{- define "netmaker.database.database" -}}
{{- if .Values.postgresql.enabled }}
{{- index .Values "postgresql" "auth" "database" }}
{{- else }}
{{- index .Values "externalDatabase" "database" }}
{{- end }}
{{- end }}

{{/*
netmaker db secret
*/}}
{{- define "netmaker.db.secret" -}}
{{- if .Values.postgresql.auth.existingSecret -}}
{{ .Values.postgresql.auth.existingSecret }}
{{- else if .Values.externalDatabase.existingSecret -}}
{{ .Values.externalDatabase.existingSecret }}
{{- else -}}
db-secret
{{- end }}
{{- end }}

{{/*
netmaker secret
*/}}
{{- define "netmaker.secret" -}}
{{- if .Values.netmaker.existingSecret -}}
{{ .Values.netmaker.existingSecret }}
{{- else -}}
netmaker-secret
{{- end }}
{{- end }}

{{/*
netmaker admin credentials secret
*/}}
{{- define "netmaker.admin.secret" -}}
{{- if .Values.netmaker.admin.existingSecret -}}
{{ .Values.netmaker.admin.existingSecret }}
{{- else -}}
netmaker-admin-secret
{{- end }}
{{- end }}

{{/*
mqtt (broker) secret
*/}}
{{- define "netmaker.mq.secret" -}}
{{- if .Values.mq.existingSecret -}}
{{ .Values.mq.existingSecret }}
{{- else -}}
mq-secret
{{- end }}
{{- end }}

{{/*
netmaker oauth secret
*/}}
{{- define "netmaker.oauth.secret" -}}
{{- if .Values.netmaker.oauth.existingSecret -}}
{{ .Values.netmaker.oauth.existingSecret }}
{{- else -}}
netmaker-oauth-secret
{{- end }}
{{- end }}

{{/*
netmaker turn secret
*/}}
{{- define "netmaker.turn.secret" -}}
{{- if .Values.netmaker.turn.existingSecret -}}
{{ .Values.netmaker.turn.existingSecret }}
{{- else -}}
turn-secret
{{- end }}
{{- end }}
