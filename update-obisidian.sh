# Create the directory if it doesn't exist
# mkdir -p /home/gaurav/Applications/Obisidian

# Navigate to the directory
echo "Updating the Obisidian"
cd /home/gaurav/Applications/Obsidian

# Download the file using wget and rename it
echo "Downloading the Obisidian"
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/Obsidian-1.4.16.AppImage -O Obsidian.AppImage

echo "Giving Permission"
chmod +x ./Obsidian.AppImage


