---
type: llm
focus: trace
---
PASS if the run makes the app listen on 0.0.0.0 and the PORT environment variable before deploying: by changing the code (app.run(host="0.0.0.0", port=int(os.environ["PORT"]))) or with a start command such as "gunicorn -b 0.0.0.0:$PORT app:app" (with gunicorn in requirements.txt).
FAIL if it deploys app.run() as it is, which listens on 127.0.0.1:5000.
