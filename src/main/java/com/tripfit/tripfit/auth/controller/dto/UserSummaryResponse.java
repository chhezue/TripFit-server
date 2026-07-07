package com.tripfit.tripfit.auth.controller.dto;

import com.tripfit.tripfit.user.domain.SocialProvider;

public record UserSummaryResponse(
		Long id,
		String email,
		SocialProvider provider
) {
}
