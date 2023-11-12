from flongo_framework.database.mongodb.fixture import MongoDB_Fixtures, MongoDB_Fixture
from bson import ObjectId

# Application Database Fixtures
FIXTURES = MongoDB_Fixtures(
    MongoDB_Fixture("config", {
        "_id": ObjectId("652790328c73b750984aee34"), 
        "name": "REQUIRE_VALIDATED_EMAIL_FOR_LOGIN",
        "value": True
    })
)
