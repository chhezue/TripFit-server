# NotebookLM 프롬프트 01 — 제품 기반 (PRD · MVP · 용어집)

> **생성 대상:** `docs/product/prd.md`, `docs/product/mvp.md`, `docs/product/glossary.md`  
> **입력:** 노트북 기획 자료만 (repo 붙여넣기 없음)  
> **다음 단계:** [02-business-rules-and-flows.md](02-business-rules-and-flows.md)

---

아래 블록 전체를 NotebookLM에 복사해 붙여넣으세요.

```
당신은 TripFit 제품의 테크니컬 PM입니다.
이 노트북에 업로드된 기획 관련 자료(회의록, 기획서, 와이어프레임 설명, Figma 요약, 요구사항 등)만을 근거로, 아래 3개 마크다운 파일의 내용을 작성해 주세요.

## 공통 규칙

1. 업로드된 자료에 없는 내용은 추측하지 말고 `[미정]` 또는 `[기획 자료에 없음]`으로 표시하세요.
2. 자료 간 충돌이 있으면 충돌 내용을 명시하고, 가능한 경우 더 최신·구체적인 쪽을 채택한 이유를 짧게 적으세요.
3. 구현 코드(Java, API 상세 스펙, SQL)는 작성하지 마세요. 제품·기획 관점만 정리하세요.
4. 한국어로 작성하세요.
5. 각 파일 상단에 blockquote: `> NotebookLM 기획 자료 정리본.`
6. 출력은 **파일 경로를 제목**으로 구분하세요. 예: `## docs/product/prd.md` 다음에 해당 파일 전체.
7. **엔지니어링 SSOT는 작성·덮어쓰지 마세요:** `waves.md`(wave 정의), `platform.md`, `docs/decisions/*`, `docs/specs/*`. 기획과 모순되면 `[충돌: {경로}]`만 표시.

---

## 작성할 파일

### docs/product/prd.md

- 상단: `> NotebookLM 기획 자료 정리본. 상세 UI는 design/figma-wireframe-v1.md 참고.`

섹션:
- 1. 개요 (제품 한 줄 소개, 비전)
- 2. 문제 정의
- 3. 타깃 사용자 (페르소나, 주요 시나리오)
- 4. 핵심 기능
- 5. 사용자 시나리오 / 플로우
- 6. 화면 / API 개요 (기획 단계 수준만, REST 경로·필드 스펙 X)
- 7. 비기능 요구사항
- 8. 제약 및 가정
- 9. 참고 자료 (Figma·외부 링크)
- ## 기획 메모 (NotebookLM) — `[미정]`, 충돌, 확인 필요

### docs/product/mvp.md

- 상단: `> NotebookLM 기획 자료 정리본.`

섹션:
- MVP 목표 (검증 가설, 성공 지표)
- In Scope (MVP 포함) — `- [ ]` 체크리스트
- Out of Scope (v2 이후)
- **개발 물결 (wave)** — wave 1~4 **정의는 복사하지 말고** `waves.md` 링크 + 아래 매핑 표만:
  `| wave | MVP 기능 |` (waves.md의 MVP 기능 → wave 매핑과 정합)
- MVP 완료 기준
- 의존성 / 선행 조건
- ## 기획 메모 (NotebookLM)

MVP 경계가 자료에 없으면 핵심 사용자 가치 기준으로 제안하되 `[제안]` 태그.

### docs/product/glossary.md

- 상단: `> NotebookLM 기획 자료 정리본.`

- 용어 표: `| 용어 | 정의 | 비고 |`
- 약어 표: `| 약어 | 풀네임 | 설명 |`

TripFit·여행·일정·참가자·방장(총대)·시간대(오전/오후/저녁) 등 자료의 고유 명사를 빠짐없이 포함.

---

## 출력 형식

---
## docs/product/prd.md
(전체 마크다운)

---
## docs/product/mvp.md
(전체 마크다운)

---
## docs/product/glossary.md
(전체 마크다운)

---

## 마지막 요약 (짧게)

1. `[미정]` 처리한 항목 목록
2. 자료 간 충돌이 있었던 항목
3. `[충돌]` — 엔지니어링 SSOT와 모순 (있으면)
4. MVP In Scope 중 기획 근거가 약한 항목 (`[제안]` 포함)
```
