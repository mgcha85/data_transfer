# MinerU API 인터페이스 명세

본 문서는 MinerU에서 제공하는 API 인터페이스에 대해 설명합니다.

## 기본 정보
- **Base URL**: `http://localhost:8000`
- **Port**: 8000 (설정 파일에서 변경 가능)
- **Log Level**: INFO

## 주요 엔드포인트

### 1. 파일 분석 (동기식)
파일을 업로드하고 분석 결과를 즉시 반환받습니다. 기본적으로 한국어 OCR이 적용됩니다.

- **URL**: `/file_parse`
- **Method**: `POST`
- **Content-Type**: `multipart/form-data`
- **Parameters**:
  - `files`: PDF 또는 이미지 파일 (필수)
  - `lang_list`: 기본값 `["korean"]`
  - `backend`: `hybrid-auto-engine` (기본값)
  - `formula_enable`: `true` (기본값)
  - `table_enable`: `true` (기본값)

### 2. 비동기 작업 제출
대용량 파일 처리를 위해 비동기식으로 작업을 제출합니다.

- **URL**: `/tasks`
- **Method**: `POST`
- **Parameters**: (파일 분석과 동일)
- **Response**: `task_id`를 포함한 JSON 객체

### 3. 작업 상태 조회
- **URL**: `/tasks/{task_id}`
- **Method**: `GET`
- **Response**: 현재 상태 (`pending`, `processing`, `completed`, `failed`) 및 진행 상황

### 4. 결과 다운로드
- **URL**: `/tasks/{task_id}/result`
- **Method**: `GET`

## 사용량 추적 (SQLite)
모든 API 호출은 `usage.db`에 자동으로 기록됩니다. 
- **파일 경로**: `./usage.db`
- **주요 컬럼**: `task_id`, `ip_address`, `file_name`, `page_count`, `duration_sec`, `status`
- **성능 최적화**: WAL (Write-Ahead Logging) 모드가 활성화되어 있어 멀티 스레드 환경에서도 안전하게 기록됩니다.
