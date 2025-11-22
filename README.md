<!--
 * @Author: liumiu2020 liumiu2020@gmail.com
 * @Date: 2025-11-22 12:16:01
 * @LastEditors: liumiu2020 liumiu2020@gmail.com
 * @LastEditTime: 2025-11-22 12:37:37
 * @FilePath: \bid-game\README.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
# Bid-lx
This project is to show commonly scenario in bid situation

### compile and generate abi
```shell
npx hardhat compile
solc --base-path . --include-path node_modules --abi x_Your_entrance_x.sol -o build/
```

### deploy to chain
```shell
npx hardhat run .\src\deploy.ts --network sepolia
```
