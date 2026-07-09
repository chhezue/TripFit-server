package com.tripfit.tripfit.auth.repository;

import com.tripfit.tripfit.auth.domain.RefreshToken;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {

  Optional<RefreshToken> findByToken(String token);

  void deleteByToken(String token);

  void deleteAllByUserId(Long userId);
}
