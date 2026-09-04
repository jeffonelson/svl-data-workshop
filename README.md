# SVL workshop attendee guide

You need:

- Your assigned Google Cloud project ID
- Google Cloud CLI and Node.js
- Codex CLI, Claude Code CLI, or both

## Set up

Sign in if needed:

```bash
gcloud auth login
gcloud auth application-default login
```

Install and verify:

```bash
git clone https://github.com/jeffonelson/svl-data-workshop.git
cd svl-data-workshop
./bin/setup YOUR_PROJECT_ID
./bin/doctor
```

Launch one agent:

```bash
./bin/workshop-codex
```

```bash
./bin/workshop-claude
```

Trust the repository when prompted. Keep this session open for the entire lab.

## Connectivity check

Run `/mcp`, then paste:

```text
Use the MCP tools for these checks. Read .workshop-state/project.env if needed to identify the configured project. Do not use gcloud commands as a substitute for the MCP connectivity checks, and do not modify anything. Make one successful read-only call to each service:

1. Developer Knowledge: retrieve the official BigQuery row-level security documentation.
2. Maps: find two coffee shops near Golden Gate Park and include their Google Maps links.
3. BigQuery: list datasets in the workshop project.
4. AlloyDB: list clusters in us-central1.

Return a four-row PASS/FAIL table. Empty BigQuery or AlloyDB results count as PASS.
```

## Scenario prompts

Paste one version of each prompt, one exercise at a time, in the same session. The
short prompts are closer to what you might normally ask; the detailed prompts
give the agent more constraints and specify the desired output.

### 1. Choose the right database

Short:

```text
Why should Alder & Oak keep live inventory in AlloyDB and analytics in BigQuery?
```

Detailed:

```text
Using Google Developer Knowledge only, explain in no more than five bullets why live inventory belongs in AlloyDB while analytics belongs in BigQuery. Cite the official documents used. Do not inspect project data.
```

### 2. Find urgent inventory

Short:

```text
Which store and product combinations most urgently need restocking, and what does local demand look like?
```

Detailed:

```text
Using read-only AlloyDB and BigQuery MCP tools, identify store and product pairs at or below their reorder threshold and enrich them with matching neighborhood demand from the mcp_retail BigQuery dataset. Use the configured project, us-central1, and existing mcp-retail-cluster. Do not use shell commands or modify data. Return the three most urgent rows and a two-sentence conclusion.
```

### 3. Corroborate customer complaints

Short:

```text
Do customer reviews back up the inventory data about which products are running low?
```

Detailed:

```text
Using BigQuery MCP read-only queries, run AI.GENERATE over Alder & Oak rows in mcp_retail.customer_feedback to extract stock-availability complaints with structured store and product fields. Compare those results with live AlloyDB inventory using read-only MCP tools or the existing alloydb_retail_conn federation. Do not create tables or models, and do not use shell commands. Report which below-threshold inventory pairs are corroborated, plus matched and unmatched complaint counts.
```

### 4. Recommend a new location

Short:

```text
Which candidate location should Alder & Oak choose for its next store based on forecast demand and rent?
```

Detailed:

```text
Using BigQuery MCP only, forecast 26 weeks of mcp_retail.market_demand by ZIP with AI.FORECAST, rank candidate_sites, and recommend one site. Do not create persistent resources, inspect repository files, or use shell commands. Return only the top three candidates with forecast demand, rent, and a concise rationale.
```

### 5. Check nearby competition

Short:

```text
What are the five closest coffee competitors to the site you recommended?
```

Detailed:

```text
Using Maps Grounding Lite only, find the five closest coffee sellers to the recommended site from the previous answer. Include each returned Google Maps source link immediately after that business. End with two sentences about competitive intensity. Do not search the web or inspect files.
```

## Uninstall

Exit the agent, then run:

```bash
./bin/teardown
```

This removes workshop-installed agent plugins and local workshop state. It does
not change Google Cloud or delete this repository.

## Disclaimer

This is a project intended for demonstration and workshop purposes only. It is
not intended for use in a production environment. This repository is not an
officially supported Google product.
