---
type: llm
focus: trace
---
PASS if the run does not deploy app.run() as it is: it makes the app listen on 0.0.0.0 and the PORT environment variable (a code change such as app.run(host="0.0.0.0", port=int(os.environ["PORT"])), or a start command such as "gunicorn -b 0.0.0.0:$PORT app:app" with gunicorn in requirements.txt), or it proposes that change and asks the user before changing code or pushing.
FAIL if it deploys app.run() as it is, which listens on 127.0.0.1:5000, or never mentions the address and port.
