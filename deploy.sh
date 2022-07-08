NODE_ENV=bscTestnet yarn spaceship:nft.deploy;
NODE_ENV=bscTestnet yarn spaceship:box.deploy;
NODE_ENV=bscTestnet yarn spaceship:update-minter-nft.task;
NODE_ENV=bscTestnet yarn spaceship:pool-mint-box.deploy;
NODE_ENV=bscTestnet yarn spaceship:update-minter-box.task;
NODE_ENV=bscTestnet yarn spaceship:enable-open-box.task;


# NODE_ENV=bscMainnet yarn spaceship:nft.deploy;
# NODE_ENV=bscMainnet yarn spaceship:box.deploy;
# NODE_ENV=bscMainnet yarn spaceship:update-minter-nft.task;
# NODE_ENV=bscMainnet yarn spaceship:pool-mint-box.deploy;
# NODE_ENV=bscMainnet yarn spaceship:update-minter-box.task;
# NODE_ENV=bscMainnet yarn spaceship:enable-open-box.task;