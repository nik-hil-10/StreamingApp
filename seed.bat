@echo off
echo Seeding the MongoDB database with sample video catalog data...

for /f "tokens=*" %%i in ('kubectl get pod -l app^=mongo -o jsonpath^="{.items[0].metadata.name}"') do set MONGO_POD=%%i

if "%MONGO_POD%"=="" (
    echo Error: Could not find MongoDB pod. Is the cluster running?
    pause
    exit /b
)

echo Found MongoDB Pod: %MONGO_POD%
echo Inserting sample videos...

kubectl exec %MONGO_POD% -- mongosh streamingapp --eval "db.videos.insertMany([{title:'The Matrix',description:'A hacker learns the true nature of his reality.',thumbnailUrl:'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=500',s3Key:'matrix.mp4',duration:136,genre:'Sci-Fi',releaseYear:1999,status:'ready',uploadedBy:ObjectId()}, {title:'Inception',description:'A thief who steals corporate secrets through dream-sharing.',thumbnailUrl:'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500',s3Key:'inception.mp4',duration:148,genre:'Sci-Fi',releaseYear:2010,status:'ready',uploadedBy:ObjectId()}, {title:'Interstellar',description:'Explorers travel through a wormhole in space in an attempt to ensure the survival of humanity.',thumbnailUrl:'https://images.unsplash.com/photo-1506443432602-ac2fcd6f54e0?w=500',s3Key:'interstellar.mp4',duration:169,genre:'Sci-Fi',releaseYear:2014,status:'ready',uploadedBy:ObjectId()}])"

echo.
echo Database seeded successfully! 
echo You can now refresh your frontend browser to see the populated video catalog.
pause
