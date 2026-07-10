# NotebookLM 프롬프트 04 — Figma · 화면 도메인 요약

> **생성 대상:** `docs/product/design/figma-wireframe-v1.md`  
> **입력:** 노트북 Figma·화면 자료 (없으면 생략)  
> **선택:** 01단계 NotebookLM PRD 출력을 `[선택]`에 붙여넣기

---

아래 블록 전체를 NotebookLM에 복사해 붙여넣으세요.

```
당신은 TripFit 백엔드 설계를 돕는 테크니컬 PM입니다.
이 노트북의 Figma 와이어프레임 설명·화면 목록·카피·필드 메모를 근거로, 프론트 픽셀 스펙이 아닌 **백엔드가 알아야 할 도메인·상태·필드** 위주 문서를 작성해 주세요.

[선택: 01단계 NotebookLM PRD 출력. repo prd.md 아님.]

## 공통 규칙

1. 픽셀·색·컴포넌트 CSS는 작성하지 마세요.
2. 자료에 없는 API·필드는 `[미정]`. 추측 금지.
3. 한국어. 상단: `> Figma에서 추출한 제품·화면·도메인 요약. 상세 기획은 prd.md·NotebookLM 산출물과 교차 검증.`
4. business-rules의 BR-ID와 연결 가능하면 `(BR-TRIP-xxx)` 표기.
5. 엔지니어링 SSOT와 충돌 시 `[충돌: docs/...]`만 표시.

---

## 작성할 파일: docs/product/design/figma-wireframe-v1.md

### 필수 섹션

#### Source
| 항목 | 값 |
|------|-----|
| 파일 | (Figma URL 또는 `[미정]`) |
| 노드 | (예: Wireframe - ver1) |
| 버전 | ver1 |

#### 제품 한 줄
(한 문장)

#### 화면 맵 (와이어프레임 섹션)
| 섹션 | 주요 화면 | 백엔드 관련성 |

섹션 예: 홈, 추천일정, 온보딩, 회원가입, 내 일정관리, 알림센터, 마이페이지

#### 핵심 도메인 (번호 목록)
각 도메인마다:
- 엔티티·상태·필드 (ERD·BR와 정합)
- 화면에서 수집하는 입력값
- 권한 (방장 vs 참여자)

포함 권장 도메인:
1. 여행방 (Trip Room) — 생성 필드, 상태, 초대
2. 일정 응답 — 시간대·상태·프라이버시
3. 추천·확정 — TOP 3, 방장 확정
4. 사용자·온보딩 — 소셜, 이름, 근무/연차
5. 알림 — 이벤트 유형·카피 (BR-NOTI-*)

#### 화면별 API 힌트 (기획 수준)
| 화면 | 필요 데이터·액션 | 관련 BR | MVP wave |
(REST 경로·request body 상세 X — "여행방 목록", "일정 PATCH" 수준)

#### 기획 메모 (NotebookLM)
- Figma만 있고 PRD에 없는 항목
- `[미정]` UI 필드
- PRD·BR와 불일치

---

## 출력 형식

---
## docs/product/design/figma-wireframe-v1.md
(전체 마크다운)

---

## 마지막 요약

1. 백엔드 신규 요구로 보이는 항목 (없으면 "없음")
2. BR-ID로 아직 매핑 안 된 Figma 규칙
3. `[충돌]` — platform/decisions/specs
```
