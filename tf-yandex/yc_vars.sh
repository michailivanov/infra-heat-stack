#!/bin/bash

# Получаем данные для аутентификации
YC_TOKEN=$(yc iam create-token 2>/dev/null)
YC_CLOUD_ID=$(yc config get cloud-id 2>/dev/null)
YC_FOLDER_ID=$(yc config get folder-id 2>/dev/null)

# Формируем JSON ответ
if [ -n "$YC_TOKEN" ] && [ -n "$YC_CLOUD_ID" ] && [ -n "$YC_FOLDER_ID" ]; then
  jq -n \
    --arg token "$YC_TOKEN" \
    --arg cloud_id "$YC_CLOUD_ID" \
    --arg folder_id "$YC_FOLDER_ID" \
    '{"token": $token, "cloud_id": $cloud_id, "folder_id": $folder_id}'
else
  echo "Ошибка: не удалось получить данные аутентификации" >&2
  exit 1
fi
