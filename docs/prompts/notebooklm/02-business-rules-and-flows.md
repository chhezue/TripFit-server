# NotebookLM 프롬프트 02 — 비즈니스 규칙 · 플로우

> **생성 대상:** `docs/product/business-rules/*.md`, `docs/product/flows/*.md`  
> **입력:** 노트북 기획 자료 + **01단계 NotebookLM 출력** (아래 `[선택]`에 붙여넣기)  
> **다음 단계:** [03-erd.md](03-erd.md)

---

아래 블록 전체를 NotebookLM에 복사해 붙여넣으세요.

```
당신은 TripFit 제품의 테크니컬 PM입니다.
이 노트북의 기획 자료와, 아래에 붙여넣은 PRD·MVP·용어집(있는 경우)을 근거로 비즈니스 규칙과 사용자 플로우 문서를 작성해 주세요.

[선택: 01단계 NotebookLM 출력 — prd.md, mvp.md, glossary.md 전체를 여기에 붙여넣기. repo 파일 아님.]

## 공통 규칙

1. 업로드 자료·붙여넣은 문서에 없는 내용은 `[미정]` 또는 `[기획 자료에 없음]`으로 표시하세요.
2. 자료 충돌 시 충돌 내용과 채택 이유를 각 파일 하단 `## 기획 메모 (NotebookLM)`에 명시하세요.
3. 구현 코드(Java, API 상세, SQL)는 작성하지 마세요.
4. 한국어. 파일 상단: `> NotebookLM 기획 자료 정리본.`
5. 출력은 `## docs/...` 경로 제목으로 파일을 구분하세요.
6. 엔지니어링 SSOT(`platform.md`, `decisions/*`, `specs/*`)와 충돌 시 `[충돌: {경로}]`만 표시.

---

## 작성할 파일 (고정 목록)

### docs/product/business-rules/trip.md

- 상단: UI 참조 `design/figma-wireframe-v1.md` (한 줄)
- 규칙 ID: `BR-TRIP-001` ~
- **표 형식 (필수):**

| 규칙 ID | 규칙명 | 조건 | 동작 | 위반 시 (에러/제약) |
| :--- | :--- | :--- | :--- | :--- |

포함 도메인: 여행방 생성·일정 응답 단위·상태·프라이버시·추천 우선순위·연차 조건·확정 권한·희망 일수 제약 등.

### docs/product/business-rules/user.md

- 규칙 ID: `BR-USER-001` ~
- 동일 표 형식
- 방장 인증, 참여자 웹 진입, 소셜 연동, 탈퇴·알림 설정 등
- Figma 유래 보조 규칙: `## 보조 규칙 (Figma·PRD)` 하단 표

### docs/product/business-rules/notification.md

- 규칙 ID: `BR-NOTI-001` ~
- 리마인드·상태 변화 알림·이벤트 카피 예시
- `## 보조 규칙 (Figma 예시 카피)` — NOTI-003~ 이벤트 문구

각 business-rules 파일 하단:
- `### [미정]` 규칙 목록
- `### 기획 확인 필요` (교차 참조: BR-USER-002 ↔ trip_member 정책 등)

### docs/product/flows/README.md

| 파일 | 설명 |
|------|------|
| (인덱스 표) | |

+ `## 기획 메모 (NotebookLM)` — MVP Out인데 플로우에 남은 항목, 확인 필요 BR

### docs/product/flows/ (개별 파일 — 파일명 고정)

| 파일 | 내용 |
|------|------|
| `trip-create.md` | 여행방 생성 |
| `trip-join.md` | 초대 링크 참여 |
| `schedule-edit.md` | 일정·근무/연차 입력 |
| `trip-confirm.md` | 추천 후보 조회·확정 |

각 플로우 파일 구조:
- **목적**
- **액터**
- **사전 조건** (BR-ID)
- **단계** (번호 목록)
- **성공 종료 조건**
- **예외 / 분기** (관련 BR-ID)
- **MVP 포함 여부** (In / Out)

MVP In Scope 기능마다 최소 1개 플로우. wave 3 알림·공유는 `trip-join` 또는 별도 분기로 `[미정]` 표시 가능.

---

## 출력 형식

---
## docs/product/business-rules/trip.md
(전체)

---
## docs/product/business-rules/user.md
(전체)

---
## docs/product/business-rules/notification.md
(전체)

---
## docs/product/flows/README.md
(전체)

---
## docs/product/flows/trip-create.md
(전체)

(나머지 flow 파일 각각)

---

## 마지막 요약 (짧게)

1. `[미정]` 처리한 규칙·플로우
2. `[충돌]` — 엔지니어링 SSOT (있으면)
3. 기획자 확인이 필요한 BR-ID 목록
4. MVP Out of Scope인데 플로우에 포함된 항목
5. 생성·갱신한 BR-ID 개수 (TRIP / USER / NOTI)
```
