# Dependency Validation

21.7% of packages recommended by AI don't exist. This is called "slopsquatting" - attackers create malicious packages with hallucinated names.

AI also recommends vulnerable package versions 50% more often than humans.

## The Risks

1. **Hallucinated packages** - AI invents package names that don't exist
2. **Slopsquatting attacks** - Attackers upload malicious packages with those fake names
3. **Vulnerable versions** - AI suggests outdated packages with known CVEs
4. **Deprecated APIs** - Code using functions that no longer exist
5. **Supply chain attacks** - Malicious code in dependencies

## Validation Steps

### Step 1: Check All Dependencies Exist

For each import/require/dependency in the code:

**Python:**
```bash
pip index versions <package_name>
```

**Node.js:**
```bash
npm view <package_name> versions
```

**Go:**
```bash
go list -m <module_path>@latest
```

If a package doesn't exist in the official registry, it's hallucinated. **Remove it immediately.**

### Step 2: Check for Known Vulnerabilities

**Python:**
```bash
pip-audit
# or
safety check
```

**Node.js:**
```bash
npm audit
```

**Go:**
```bash
govulncheck ./...
```

### Step 3: Check for Outdated Packages

**Python:**
```bash
pip list --outdated
```

**Node.js:**
```bash
npm outdated
```

### Step 4: Verify Package Legitimacy

For any unfamiliar package, check:
- [ ] Does it exist on the official registry (PyPI, npm, etc.)?
- [ ] Does it have a legitimate maintainer with history?
- [ ] Does it have consistent download patterns over time?
- [ ] Is the GitHub repo real and active?
- [ ] Do the download numbers make sense (not 0 or suspiciously low)?

## Red Flags

Watch for these signs of hallucinated or malicious packages:

- Package name very similar to a popular package (typosquatting)
- Package has very few downloads
- Package was created very recently
- No documentation or sparse README
- GitHub repo doesn't exist or is empty
- Maintainer has no other packages
- Package name sounds plausible but you've never heard of it

## Checklist

- [ ] All dependencies verified to exist in official registries
- [ ] No known vulnerabilities (or vulnerabilities acknowledged and planned)
- [ ] No severely outdated packages (major versions behind)
- [ ] Lock file (package-lock.json, Pipfile.lock, go.sum) is committed
- [ ] No suspicious or unfamiliar packages

## Output Format

```
## Dependency Validation Results

### Status: [CLEAN / HAS ISSUES / CRITICAL]

### Hallucinated Packages (DON'T EXIST)
[List or "None found"]

### Vulnerable Packages
[List with CVEs and severity, or "None found"]

### Outdated Packages
[List with current vs latest version, or "All up to date"]

### Suspicious Packages (Verify Manually)
[List any unfamiliar packages that need human verification]

### Recommendations
1. [Action items]
```

## Remember

- 43% of hallucinated packages appear repeatedly - they're not random
- One fake package got 30,000 downloads in 3 months
- Always verify packages you don't recognize
- Use lock files to pin versions
- Run dependency audits in CI
