echo 'Building English documentation'
cd en && mkdocs build --clean && cd ..
echo 'Building Japanese documentation'
cd ja && mkdocs build --clean && cd ..
    
