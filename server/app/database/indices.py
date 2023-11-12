from flongo_framework.database.mongodb.index import MongoDB_Indices, MongoDB_Index

# Application Database Indices
INDICES = MongoDB_Indices(
    # Config
    MongoDB_Index("config", "name", properties={"unique": True}),
    # Users
    MongoDB_Index(
        "users", "username", 
        properties={"unique": True}, 
        #compound_index=MongoDB_Index("users", "password")
    ),
    MongoDB_Index("users", "email_address", properties={"unique": True}),
    # Email Confirmation
    MongoDB_Index("email_confirmations", "createdOn", properties={"expireAfterSeconds": 600}),
)
