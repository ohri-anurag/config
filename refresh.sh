echo "Copying bashrc"
cp ~/.bashrc ./
cp ~/notify.sh ./

echo "Copying tasks.json"
cp ~/tasks.json ./

echo "Copying nvim files:"
echo "- init.lua"
cp ~/.config/nvim/init.lua ./nvim/

echo "- telescope-hoogle.lua"
cp ~/.config/nvim/plugin/telescope-hoogle.lua ./nvim/plugin/

echo "- .nvimrc.lua(haskell)"
cp ~/bellroy/haskell/.nvimrc.lua ./nvim/haskell/

echo "- .nvimrc.lua(bellroy-com-cms-content)"
cp ~/bellroy/bellroy-com-cms-content/.nvimrc.lua ./nvim/bellroy-com-cms-content/

echo "Copying yazi config"
cp ~/.config/yazi/yazi.toml ./yazi/
cp ~/.config/yazi/theme.toml ./yazi/

echo "Copying Passwords Database"
cp ~/Passwords.kdbx ./

echo "Copying .gitconfig"
cp ~/.gitconfig ./
