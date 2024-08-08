# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn, firestore_fn, db_fn
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
app = initialize_app()
#
#
@https_fn.on_request()
def addmessage(req: https_fn.Request) -> https_fn.Response:
    """Take the text parameter passed to this HTTP endpoint and insert it into
    a new document in the messages collection."""
    # Grab the text parameter.
    original = req.args.get("text")
    if original is None:
        return https_fn.Response("No text parameter provided", status=400)

    firestore_client: google.cloud.firestore.Client = firestore.client()

    # Push the new message into Cloud Firestore using the Firebase Admin SDK.
    _, doc_ref = firestore_client.collection("messages").add(
        {"original": original}
    )

    # Send back a message that we've successfully written the message
    return https_fn.Response(f"Message with ID {doc_ref.id} added.")

@firestore_fn.on_document_created(document="diary/{pushId}")
def create_diary_entry(
    event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None],
) -> None:
    # 데이터베이스에 저장된 데이터 가져오기
    doc_ref = db_fn.collection('diary').document()
    doc = doc_ref.get()

    # HTTP 요청 보내기
    response = requests.post('http://127.0.0.1:8000/', data=doc.to_dict())

    # 응답 결과를 데이터베이스에 업데이트
    doc_ref.update({
        'result': response.text
    })

    return 'Diary entry created and updated.'