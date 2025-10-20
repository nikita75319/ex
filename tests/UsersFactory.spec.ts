import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { MakeNewUser, UsersFactory } from '../build/UsersFactory/UsersFactory_UsersFactory';
import '@ton/test-utils';
import { User } from '../build/User/User_User';

describe('UsersFactory', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let usersFactory: SandboxContract<UsersFactory>;
    
    beforeEach(async () => {
        blockchain = await Blockchain.create();
        deployer = await blockchain.treasury('deployer');
        usersFactory = blockchain.openContract(await UsersFactory.fromInit(deployer.address));
    });

    it('should deploy UsersFactory', async () => {
        const preState = await blockchain.getContract(usersFactory.address);
        expect(preState.accountState?.type).toEqual('uninit');
        const deployResult = await deployer.send({
            to: usersFactory.address,
            value: toNano('0.1'),
            sendMode: 1,
            init: { code: usersFactory.init?.code, data: usersFactory.init?.data },
        });
        const postState = await blockchain.getContract(usersFactory.address);
        expect(postState.accountState?.type).toEqual('active');
        
    })

    it('should create user', async () => {
        const message: MakeNewUser = {
            $$type: 'MakeNewUser',
            name: "test",
            deliveryAddress: "test"
        }

        await usersFactory.send(
            deployer.getSender(), 
            {value: toNano("0.5")}, 
            message
        );

        const userAddr = await usersFactory.getUserAddress(1n);
        const user = blockchain.openContract(User.fromAddress(userAddr));
        
        const state = await blockchain.getContract(userAddr);
        console.log(userAddr);
        expect(state.accountState?.type).toEqual('active');
    })
});
