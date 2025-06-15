# AI Model Training Environment

This project provides a containerized environment for AI model training using Docker.

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Build and Run

1.  **Build the Docker image:**
    Build the necessary Docker image by running the following command in the project root directory.

    ```bash
    docker compose build
    ```

2.  **Start the container:**
    Start the service in detached mode.

    ```bash
    docker compose up -d
    ```

## VSCode Development Container

This project is configured to be used with VSCode Dev Containers.

1.  Make sure you have the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension installed in VSCode.
2.  Open the project folder in VSCode.
3.  Click on the "Reopen in Container" button that appears in the bottom right corner.