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

### 1. Clone the repository

```bash
git clone https://github.com/jeffonelson/svl-data-workshop.git
cd svl-data-workshop
```

### 2. Configure and verify

Replace the placeholder below, including the angle brackets, with your assigned
Google Cloud project ID.

`./bin/setup` checks access to your assigned project and secrets, then installs
and configures the Data Agent Kit plugin for each supported agent on your computer.

```bash
./bin/setup <INSERT_YOUR_GOOGLE_CLOUD_PROJECT_ID>
```

`./bin/doctor` runs read-only checks for the required software, Google Cloud
authentication, plugin installation, and MCP configuration.

```bash
./bin/doctor
```

### 3. Launch one agent

Use a workshop launcher instead of running `codex` or `claude` directly so it
can load the workshop credentials and project settings before starting the agent.

```bash
./bin/workshop-codex
```

```bash
./bin/workshop-claude
```

Trust the repository when prompted. Keep this session open for the entire lab.

## Connectivity check

First, run `/mcp` in the agent and confirm that the Developer Knowledge, Maps
Grounding Lite, Cloud Run, BigQuery, and AlloyDB MCP servers are loaded.

Cloud Run is the one server here that needs no API key: it acts as you, using
the Google Cloud credentials you logged in with. Seeing it listed is not proof
that it works, because it lists its tools without checking credentials at all.
`./bin/doctor` makes a real call to it, so trust the doctor over the list.

Then paste the following prompt into the same agent session and run it:

```text
Use the MCP tools for these checks. Make one successful read-only call to each service:

1. Developer Knowledge: retrieve the official BigQuery row-level security documentation.
2. Maps: find two coffee shops near Golden Gate Park and include their Google Maps links.
3. BigQuery: list datasets in the workshop project.
4. AlloyDB: list clusters in us-central1.

Return a four-row PASS/FAIL table. Empty BigQuery or AlloyDB results count as PASS.
```

## Charlie's expansion scenario

Charlie's Coffee operates six Austin stores and is choosing where to open
next. Each section has one featured prompt. Run the featured prompts for the
shortest path through the scenario, then choose any optional follow-ups that
match your interests and available time. Continue in the same agent session so
later prompts can build on earlier findings.

### Frame the decision

#### Featured prompt

```text
According to the official Google Cloud documentation, why might AlloyDB be a
better home for live inventory than BigQuery, and when would that choice stop
making sense?
```

#### Optional follow-ups

```text
How can we analyze AlloyDB and BigQuery together without first building another ETL pipeline? Use the official Google Cloud documentation and cite the documents you use.
```

```text
Charlie's wants to open a seventh Austin store. Help me make a recommendation we can defend. Before running any analysis, what evidence would you want, and where would you expect to find it?
```

### Investigate unmet demand

#### Featured prompt

```text
Where is Charlie's currently failing to meet customer demand?
```

#### Optional follow-ups

```text
Can stock-movement history explain how those shortages developed?
```

```text
Use BigQuery AI to structure the customer-review evidence. Does it independently corroborate the inventory data?
```

```text
Can you combine the operational and analytical evidence in one analysis without copying the AlloyDB data into BigQuery first?
```

### Choose a new location

#### Featured prompt

```text
Use BigQuery AI.FORECAST to forecast market demand for the candidate ZIP codes,
then translate it into plausible store revenue using comparable-store capture
rates, account for rent, and recommend one site.
```

#### Optional follow-ups

```text
What separates Charlie's strongest store markets from its weakest ones?
```

```text
Which candidate site should Charlie's choose, and how confident are you?
```

```text
What assumptions have the most influence on the ranking, and what would need to change for the runner-up to win?
```

### Test the recommendation in the real world

#### Featured prompt

```text
Stress-test your recommended site using what exists around it today. What
real-world evidence strengthens or weakens the recommendation? Include the
Google Maps source link immediately after every place-based claim.
```

#### Optional follow-ups

```text
Does nearby coffee competition indicate saturation, or does it validate demand?
```

```text
Which nearby residential areas fall within a 10-minute driving radius from the site, as a proxy for DoorDash or Uber Eats delivery reach?
```

```text
Which nearby residential buildings and neighborhood anchors are within a 10-minute walk of the site and could contribute launch-day foot traffic?
```

### Plan the launch

#### Featured prompt

```text
Design a launch-week plan for the recommended site using everything we have learned.
```

#### Optional follow-ups

```text
If we held an outdoor launch event at the recommended site this weekend, what do the hourly and daily weather forecasts suggest, and how should we adjust the plan?
```

```text
Which residential buildings near the site are worth a launch-week promotion?
```

```text
Which nearby gyms and coworking spaces should we approach as launch partners?
```

```text
Before we promote Guatemala Geisha beans on DoorDash, identify the store that would fulfill those orders and check whether it can fulfill them right now.
```

```text
Revise the launch plan based on what you discovered.
```

### Share the decision

#### Featured prompt

```text
Turn the analysis into an executive recommendation: one site, one runner-up, three launch actions, three major risks, and an evidence trail for every conclusion.
```

#### Optional follow-ups

```text
Build a simple read-only map dashboard that communicates the recommendation and lets someone inspect the supporting inventory, TimesFM demand forecast, and nearby-place evidence.
```

```text
Audit every number and label in the dashboard against the analysis, then deploy it to Cloud Run and return the live URL.
```

Cloud Run deployment creates or replaces a real service. Approve it only when
you are ready to publish the dashboard.

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
