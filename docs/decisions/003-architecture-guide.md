# 003 — Vertical Slice 아키텍처 가이드

- **상태:** 확정
- **날짜:** 2026-07-06
- **관련:** `docs/architecture.md`, `.cursor/rules/spring-boot-java.mdc`

## 맥락

TripFit 백엔드는 MVP 단계의 Spring Boot 단일 Gradle 모듈이다. **도메인 주도 설계(DDD) 원칙은 전면 폐지**했으며, 오버엔지니어링 없이 개발 생산성을 우선한다.

대신 **기능 중심 Vertical Slice**로 코드를 묶고, 슬라이스 내부는 익숙한 **Controller / Service / Repository** 레이어를 사용한다. JPA 연관관계(`@ManyToOne`, 지연 로딩 등)를 자유롭게 활용한다.

## 결정

1. **단일 모듈 모노리스** — MVP는 Gradle 모듈 분리 없이 하나의 API 서버.
2. **슬라이스 = 기능 단위** — `auth`, `user`, `trip` 등.
3. **슬라이스 내부 레이어** — `controller` → `service` → `domain` → `repository`.
4. **공통 코드** — `common/` (설정, 예외, 공유 DTO, 베이스 엔티티).
5. **API 계약** — Controller는 DTO만 노출. Entity를 HTTP 응답으로 직접 반환하지 않음.
6. **JPA** — ERD 기준 연관관계·객체 그래프 탐색 허용. 기본 `FetchType.LAZY`.

## 슬라이스 구조

```
com.tripfit.tripfit.{feature}/
├── controller/       # @RestController, dto/ (요청·응답)
├── service/          # @Transactional 비즈니스 로직, 외부 연동(social 등)
├── domain/           # JPA @Entity, enum (핵심 비즈니스 모델)
├── repository/       # JpaRepository, 기술 영속화 엔티티(RefreshToken 등)
└── config/           # 슬라이스 전용 설정 (선택)
```

### 패키지 배치 (실용 규칙)

| 종류 | 위치 | 예 |
|------|------|-----|
| REST·DTO | `{feature}/controller/`, `controller/dto/` | `AuthController`, `LoginRequest` |
| 비즈니스·외부 API | `{feature}/service/` | `AuthService`, `GoogleTokenVerifier` |
| 핵심 Entity | `{feature}/domain/` | `User`, `Trip`, `TripMember` |
| DB 접근 | `{feature}/repository/` | `UserRepository`, `RefreshToken` |
| 공통 베이스 | `common/domain/` | `BaseTimeEntity`, `SoftDeleteEntity` |

`domain/`이 없는 슬라이스(예: `auth`)도 괜찮다. `RefreshToken`처럼 인증 전용 영속화는 `auth/repository/`에 둔다.

## 레이어 책임 (최소 규칙)

| 레이어 | 할 일 | 하지 말 것 |
|--------|-------|------------|
| **controller** | HTTP, DTO 변환, `@Valid` | 비즈니스 로직, `@Transactional` |
| **service** | 유스케이스 조율, 트랜잭션, Repository·외부 API 호출 | HTTP·Servlet API 직접 사용 |
| **domain** | JPA Entity, enum | DTO, 외부 API 호출 |
| **repository** | JpaRepository, (선택) 기술용 @Entity | Controller |

BR-* 규칙은 service 또는 domain 중 읽기 쉬운 곳에 둔다.

## 하지 않는 것 (MVP)

- DDD(애그리거트, BC, ID-only 참조 강제 등)
- 이벤트 소싱, CQRS, 별도 Gradle 모듈 분리

## 후속 작업

- [x] Vertical Slice + Controller/Service/Repository 구조 적용
- [x] `RefreshToken` → `auth/repository/`
- [ ] API envelope 프론트 합의 후 `common/api` 확정
