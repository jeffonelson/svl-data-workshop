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

## Alder & Oak expansion scenario

Alder & Oak Coffee operates six Austin stores and is choosing where to open
next. Use these prompts as starting points. They build on one another, but each
investigation can also stand on its own.

### Frame the decision

```text
Alder & Oak wants to open a seventh Austin store. Help me make a recommendation we can defend. Before running any analysis, what evidence would you want, and where would you expect to find it?
```

```text
We keep live inventory in AlloyDB and analytical data in BigQuery. Challenge that design using official Google Cloud documentation, and cite the documents you use.
```

```text
How can we analyze those systems together without first building another ETL pipeline?
```

### Investigate unmet demand

```text
Where is Alder & Oak currently failing to meet customer demand?
```

```text
Can stock-movement history explain how those shortages developed?
```

```text
Use BigQuery's built-in AI to structure the customer-review evidence. Does it independently corroborate the inventory data?
```

```text
Can you combine the operational and analytical evidence in one analysis without copying the AlloyDB data into BigQuery first?
```

### Choose a new location

```text
What separates Alder & Oak's strongest store markets from its weakest ones?
```

```text
Which candidate site should Alder & Oak choose, and how confident are you?
```

```text
Forecast market demand for the candidate ZIP codes and translate it into plausible store revenue using capture rates from comparable stores. Account for rent in the recommendation.
```

```text
What assumptions have the most influence on the ranking, and what would need to change for the runner-up to win?
```

### Test the recommendation in the real world

```text
Try to talk me out of your recommended site using what exists around it today.
```

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

```text
Design a launch-week plan for the recommended site using everything we have learned.
```

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
Before we promote Guatemala Geisha beans on DoorDash, check whether we can actually fulfill delivery orders for it right now.
```

```text
Revise the launch plan based on what you discovered.
```

### Share the decision

```text
Turn the analysis into an executive recommendation: one site, one runner-up, three launch actions, three major risks, and an evidence trail for every conclusion.
```

```text
Build a simple read-only map dashboard that communicates the recommendation and lets someone inspect the supporting inventory, demand forecast, and nearby-place evidence.
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
