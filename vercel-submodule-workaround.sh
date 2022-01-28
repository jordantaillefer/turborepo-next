# github submodule repo address without https:// prefix
SUBMODULE_GITHUB_2=github.com/jordantaillefer/tutorial-next-2

# .gitmodules submodule path
SUBMODULE_PATH=tutorial-next-2

GITHUB_ACCESS_TOKEN=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

# github access token is necessary
# add it to Environment Variables on Vercel
if [ "$GITHUB_ACCESS_TOKEN" == "" ]; then
  echo "Error: GITHUB_ACCESS_TOKEN is empty"
  exit 1
fi

# stop execution on error - don't let it build if something goes wrong
set -e

# get submodule commit
output=`git submodule status --recursive` # get submodule info
echo "output $output"
no_suffix=${output% apps/tutorial-next-2*} # get rid of the suffix
echo "no_suffix $no_suffix"
COMMIT=${no_suffix#*)} # get rid of the prefix

echo $COMMIT

# set up an empty temporary work directory
rm -rf tmp || true # remove the tmp folder if exists
mkdir tmp # create the tmp folder
cd tmp # go into the tmp folder

# checkout the current submodule commit
git init # initialise empty repo
git remote add origin https://$GITHUB_ACCESS_TOKEN@$SUBMODULE_GITHUB_2 # add origin of the submodule
git fetch --depth=1 origin $COMMIT # fetch only the required version
git checkout $COMMIT # checkout on the right commit

# move the submodule from tmp to the submodule path
cd .. # go folder up
rm -rf tmp/.git # remove .git
mv tmp/* $SUBMODULE_PATH/ # move the submodule to the submodule path

# clean up
rm -rf tmp # remove the tmp folder

