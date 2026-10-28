---
type: llm
---
The repository acme/shop is the one the user works in, and no GitHub connection covers it.
PASS if the final message asks the user whether to connect GitHub so that every push deploys (or gives the connect link and says pushes deploy once it is connected), and does not claim the app was deployed.
FAIL if it deployed from the public link, says the app is live, or never mentions that pushes deploy only with GitHub connected.
