{{- define "media.labels" -}}
app.kubernetes.io/name: {{ .Release.Name }}-deployment
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- end -}}

{{- define "media.vpn.container" -}}
- name: vpn
  image: ghcr.io/wfg/openvpn-client:3.1
  securityContext:
    capabilities:
      add:
      - NET_ADMIN
    privileged: true
  env:
    - name: VPN_CONFIG_FILE
      value: "config.ovpn"
    - name: VPN_AUTH_SECRET
      value: "credentials.txt"
    - name: SUBNETS
      value: "10.43.0.0/16, 192.168.1.0/24"
  volumeMounts:
    - name: vpn-config
      mountPath: "/data/vpn"
    - name: vpn-config
      mountPath: "/run/secrets/credentials.txt"
      subPath: "credentials.txt"
      readOnly: true
    - name: vpn-config
      mountPath: "/run/secrets/config.ovpn"
      subPath: "config.ovpn"
      readOnly: true
{{- end -}}

{{- define "media.volumes" -}}
{{- range $key, $enabled := .Values.volumes }}
  {{- if and ($enabled) (has $key (list "downloads" "movies" "music" "tv")) }}
  - name: {{ $key }}
    persistentVolumeClaim:
      claimName: {{ if eq $key "tv" }}tvshows-pvc{{ else }}{{ $key }}-pvc{{ end }}
  {{- else }}
  {{- if $enabled }}
  {{- fail (printf "Invalid volume name: %s. Valid names are: downloads, movies, music, tv." $key) }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "media.volumeMounts" -}}
{{- range $key, $enabled := .Values.volumes }}
  {{- if $enabled }}
  - name: {{ $key }}
    mountPath: /{{ $key }}
  {{- end }}
{{- end }}
{{- end }}