# MinerU 설치 및 구성 가이드

본 문서는 MinerU를 사내 오프라인 환경에서 설치하고 구성하기 위한 지침입니다.

## 1. 전제 조건
- **OS**: Linux (추천: Ubuntu 22.04 LTS 이상)
- **Python**: 3.10 이상 (3.11 추천)
- **도구**: `uv` (빠른 패키지 관리 및 의존성 해결용)
- **하드웨어**: CPU (Intel/AMD) 8코어 이상, 16GB RAM 권장

## 2. 의존성 설치 (인터넷 가능 환경)
사내 오프라인 망으로 이동하기 전, 필요한 패키지를 미리 설치합니다.
```bash
# uv 설치
curl -LsSf https://astral.sh/uv/install.sh | sh

# 의존성 동기화
uv sync
```

## 3. 모델 다운로드
모든 모델은 `./models` 디렉토리에 저장됩니다.
```bash
python3 scripts/download_models.py --dir ./models --source huggingface
```

## 4. 환경 변수 설정
`.env.prod` 파일에 프로젝트 설정을 기록합니다.
- `MINERU_DEVICE_MODE`: `cpu` (고정)
- `MINERU_MODEL_SOURCE`: `local` (고정)
- `MINERU_TOOLS_CONFIG_JSON`: `./mineru.json` (고정)
- `MINERU_API_PORT`: API 서버 포트 (기본: 8000)

## 5. 서비스 기동 및 중지
- 기동: `./start.sh prod` (또는 `dev`)
- 중지: `./stop.sh`

## 6. 사용량 관리
`usage.db` 파일을 통해 시스템 사용 현황을 모니터링할 수 있습니다.
SQLite 브라우저 등을 사용하여 `usage_logs` 테이블을 조회하십시오.
- `PRAGMA journal_mode=WAL;` 설정으로 인해 동시성이 향상되었습니다.
