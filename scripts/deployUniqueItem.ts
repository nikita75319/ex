import { toNano } from '@ton/core';
import { UniqueItem } from '../build/UniqueItem/UniqueItem_UniqueItem';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const uniqueItem = provider.open(await UniqueItem.fromInit());

    await uniqueItem.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        null,
    );

    await provider.waitForDeploy(uniqueItem.address);

    // run methods on `uniqueItem`
}
