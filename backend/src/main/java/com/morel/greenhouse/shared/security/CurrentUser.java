package com.morel.greenhouse.shared.security;

public record CurrentUser(
        Long id,
        String username,
        String role
) {
    public boolean admin() {
        return "ADMIN".equals(role);
    }
}
