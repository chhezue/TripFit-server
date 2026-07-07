package com.tripfit.tripfit.user.domain;

import com.tripfit.tripfit.common.domain.SoftDeleteEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(
		name = "user",
		uniqueConstraints = @UniqueConstraint(columnNames = {"provider", "social_id"})
)
public class User extends SoftDeleteEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(nullable = false)
	private String socialId;

	@Enumerated(EnumType.STRING)
	@Column(nullable = false)
	private SocialProvider provider;

	@Column
	private String email;

	protected User() {
	}

	public User(String socialId, SocialProvider provider, String email) {
		this.socialId = socialId;
		this.provider = provider;
		this.email = email;
	}

	public Long getId() {
		return id;
	}

	public String getSocialId() {
		return socialId;
	}

	public void setSocialId(String socialId) {
		this.socialId = socialId;
	}

	public SocialProvider getProvider() {
		return provider;
	}

	public void setProvider(SocialProvider provider) {
		this.provider = provider;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
}
