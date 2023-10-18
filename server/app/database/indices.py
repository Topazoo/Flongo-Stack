from flongo_framework.database.mongodb.index import MongoDB_Indices, MongoDB_Index

# Application Database Indices
INDICES = MongoDB_Indices(
    MongoDB_Index("config", "name", properties={"unique": True})
)
