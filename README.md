# Cementic-versioning
Here's we add bash script that we can use in a GitHub Actions workflow to handle semantic versioning. This script will prompt the user to choose between a major, minor, or patch version upgrade.

# Workflow Explanation
Trigger: This workflow is triggered manually using workflow_dispatch, allowing you to choose when to bump the version.

Steps:

The repository is checked out.
Node.js is set up.
Dependencies are installed.
The version-bump.sh script is executed, prompting the user to choose between a major, minor, or patch version bump.
This setup ensures that every time you run the workflow, it will ask you for the type of version bump you'd like to apply.
