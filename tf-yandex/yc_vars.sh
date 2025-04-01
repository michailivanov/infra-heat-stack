#!/usr/bin/env bash

# Получение IAM-токена для аутентификации в Yandex Cloud
# Команда 'yc iam create-token' создает новый IAM-токен
# Результат сохраняется в переменной YC_TOKEN
YC_TOKEN=$($HOME/yandex-cloud/bin/yc iam create-token)

# Получение идентификатора облака (cloud-id) из конфигурации YC CLI
# Команда 'yc config get cloud-id' возвращает текущий cloud-id
# Результат сохраняется в переменной YC_CLOUD_ID
YC_CLOUD_ID=$($HOME/yandex-cloud/bin/yc config get cloud-id)

# Получение идентификатора каталога (folder-id) из конфигурации YC CLI
# Команда 'yc config get folder-id' возвращает текущий folder-id
# Результат сохраняется в переменной YC_FOLDER_ID
YC_FOLDER_ID=$($HOME/yandex-cloud/bin/yc config get folder-id)

# Формирование JSON-объекта с полученными данными с помощью утилиты jq
echo $(jq --null-input \          # Создание JSON из пустого ввода
          --arg token "$YC_TOKEN" \        # Передача токена как аргумента
          --arg cloud_id "$YC_CLOUD_ID" \  # Передача cloud_id как аргумента
          --arg folder_id "$YC_FOLDER_ID" \ # Передача folder_id как аргумента
          '{"token": $token, "cloud_id": $cloud_id, "folder_id": $folder_id}' # Шаблон JSON
          )

# Итоговый вывод будет выглядеть так:
# {
#   "token": "t1.9euelZq...",
#   "cloud_id": "b1gvm...",
#   "folder_id": "b1g88..."
# }