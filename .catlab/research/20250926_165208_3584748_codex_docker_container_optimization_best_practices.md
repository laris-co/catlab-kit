## Research Report: Docker container optimization best practices

### Executive Summary
Recent Docker platform updates—Buildx 0.28.0 and Engine 28.x—focus on cache-aware builds and remote builders, while Docker Build Cloud guidance stresses lighter contexts for networked builds; simultaneously, 2025 security advisories urge fast Desktop patching and hardened base images, and new research shows automated Dockerfile refactoring can sharply reduce image size and rebuild time. (https://docs.docker.com/build/release-notes/, https://docs.docker.com/engine/release-notes/28/, https://docs.docker.com/build-cloud/optimization/, https://docs.docker.com/security/security-announcements/, https://www.globenewswire.com/news-release/2025/05/19/3084038/0/en/Docker-Announces-Hardened-Images-Catalog-to-Strengthen-Enterprise-Software-Supply-Chain-Security.html, https://arxiv.org/abs/2501.14131)

### Key Findings
- Build acceleration now hinges on BuildKit features such as cache mounts and ordered layers, plus remote caches and slim contexts; CI platforms like Bitbucket Pipelines may require disabling default Docker caches or switching to self-hosted runners to benefit. (https://docs.docker.com/build/cache/optimize/, https://docs.docker.com/build-cloud/optimization/, https://support.atlassian.com/bitbucket-cloud/kb/pipelines-default-docker-cache-not-working-for-docker-build-steps/)
- Security posture demands staying current with Desktop 4.44.3 for CVE-2025-9074, adopting Docker Hardened Images, and defending against layer-tampering exploits like gh0stEdit through continuous scanning and signed supply chains. (https://docs.docker.com/security/security-announcements/, https://www.techradar.com/pro/security/a-critical-docker-desktop-security-flaw-puts-windows-hosts-at-risk-of-attack-so-patch-now, https://www.globenewswire.com/news-release/2025/05/19/3084038/0/en/Docker-Announces-Hardened-Images-Catalog-to-Strengthen-Enterprise-Software-Supply-Chain-Security.html, https://arxiv.org/abs/2506.08218)
- Emerging automation—ranging from refactoring assistants to instruction re-orchestration—reports average rebuild-time reductions above 25%, reinforcing investment in AI-driven Dockerfile maintenance. (https://arxiv.org/abs/2501.14131, https://arxiv.org/abs/2504.01742)

### Technical Specifications
- **Docker Engine 28.x (2025):** Packages BuildKit v0.20.2, runc v1.2.6, and containerd v1.7.26 (March 25, 2025), with subsequent 28.4.0 updates adding CLI fixes and GPU support—plan phased upgrades tested against Compose. (https://docs.docker.com/engine/release-notes/28/)
- **Docker Buildx 0.28.0 (September 3, 2025):** Introduces Dockerfile v1.18 syntax, improved `buildx du` formatting, and Git URL enhancements for richer cache control. (https://docs.docker.com/build/release-notes/)
- **Security Baselines:** Patch to runc ≥1.1.12, BuildKit ≥0.12.5, and Engine ≥25.0.2 per January 31, 2024 advisory, and upgrade Docker Desktop to ≥4.44.3 to mitigate CVE-2025-9074. (https://www.docker.com/blog/docker-security-advisory-multiple-vulnerabilities-in-runc-buildkit-and-moby/, https://docs.docker.com/security/security-announcements/)
- **Hardened Base Images:** Docker Hardened Images (May 19, 2025) deliver minimal, non-root, continuously scanned bases aligned with SLSA Level 3 for enterprise supply chains. (https://www.globenewswire.com/news-release/2025/05/19/3084038/0/en/Docker-Announces-Hardened-Images-Catalog-to-Strengthen-Enterprise-Software-Supply-Chain-Security.html)
- **CI/CD Compatibility:** Bitbucket Pipelines’ predefined Docker cache remains incompatible with BuildKit-enabled steps; disable `DOCKER_BUILDKIT` or migrate to self-hosted runners with remote caches. (https://support.atlassian.com/bitbucket-cloud/kb/pipelines-default-docker-cache-not-working-for-docker-build-steps/)
- **Runtime Guardrails:** Enforce `--cpus`, `--memory`, `.dockerignore`, multi-stage builds, and non-root users to limit resource exhaustion and attack surface. (https://docs.docker.com/engine/containers/resource_constraints/, https://docs.docker.com/build/building/best-practices/, https://docs.docker.com/build/building/multi-stage/)

### References & Sources
- https://docs.docker.com/build/cache/optimize/ (Accessed 2025-09-26)
- https://docs.docker.com/build/building/best-practices/ (Accessed 2025-09-26)
- https://docs.docker.com/build/building/multi-stage/ (Accessed 2025-09-26)
- https://docs.docker.com/build-cloud/optimization/ (Accessed 2025-09-26)
- https://docs.docker.com/build-cloud/ (Accessed 2025-09-26)
- https://support.atlassian.com/bitbucket-cloud/kb/pipelines-default-docker-cache-not-working-for-docker-build-steps/ (Updated 2025-02-28)
- https://docs.docker.com/security/security-announcements/ (Last updated 2025-08-20)
- https://www.techradar.com/pro/security/a-critical-docker-desktop-security-flaw-puts-windows-hosts-at-risk-of-attack-so-patch-now (Published 2025-08-26)
- https://www.docker.com/blog/docker-security-advisory-multiple-vulnerabilities-in-runc-buildkit-and-moby/ (Published 2024-01-31)
- https://docs.docker.com/engine/release-notes/28/ (Published 2025-02-19, ongoing updates)
- https://docs.docker.com/build/release-notes/ (Published 2025-09-03)
- https://www.globenewswire.com/news-release/2025/05/19/3084038/0/en/Docker-Announces-Hardened-Images-Catalog-to-Strengthen-Enterprise-Software-Supply-Chain-Security.html (Published 2025-05-19)
- https://arxiv.org/abs/2501.14131 (Published 2025-01-23)
- https://arxiv.org/abs/2504.01742 (Published 2025-04-02)
- https://arxiv.org/abs/2506.08218 (Published 2025-06-09)
- https://docs.docker.com/engine/containers/resource_constraints/ (Accessed 2025-09-26)

### Conclusion
Organizations that pair cache-aware BuildKit pipelines with remote builders, enforce current security baselines (including Hardened Images and timely Desktop patches), and adopt automated Dockerfile refactoring are best positioned to deliver fast, resilient containers amid 2025’s evolving performance and supply-chain risks. (https://docs.docker.com/build-cloud/optimization/, https://docs.docker.com/security/security-announcements/, https://www.globenewswire.com/news-release/2025/05/19/3084038/0/en/Docker-Announces-Hardened-Images-Catalog-to-Strengthen-Enterprise-Software-Supply-Chain-Security.html, https://arxiv.org/abs/2504.01742)
