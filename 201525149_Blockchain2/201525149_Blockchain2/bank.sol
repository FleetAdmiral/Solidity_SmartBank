pragma solidity ^0.4.17;
contract Bank {
    // struct jointBalance
    // {
    //     address ja1;
    //     address ja2;
    // }

    mapping (address => uint) balances;
    mapping (address => uint256) amnt_fd;
    mapping (address => uint256) time_start;

    mapping (address => address) joint;
    mapping (address => uint256) jBalance;

    address curr_owner;
    uint256 min_bal=100;   //minimum amount that must always be in the bank
    uint256 min_with=10;  //minimum amount to withdraw
    uint256 min_sub=10;  //minimum amount that must be deposited at one time
    uint256 time_fd=400;//amount of time to wait for fixed deposit

    function Bank() public {

    }

    function set_owner() public {
        curr_owner = msg.sender; // setting owner owner of this contract
    }

    function makeAccount(uint256 bal) public {
        if(bal>=min_bal)
        {
            balances[msg.sender]=bal;
            amnt_fd[msg.sender]=0;
        }
    }

    function transferMoney(address receiver, uint256 amount) public {
        if((balances[msg.sender]-amount)>=min_bal)
        {
            if(amnt_fd[msg.sender]>0)
            {
                if((now-time_start[msg.sender])<time_fd)
                {
                    if((balances[msg.sender]-amount)>=amnt_fd[msg.sender])
                    {
                    balances[msg.sender] = balances[msg.sender]-amount;
                    balances[receiver] = balances[receiver]+amount;
                    }
                }
                else
                {
                    balances[msg.sender] = balances[msg.sender]-amount;
                    balances[receiver] = balances[receiver]+amount;
                }
            }
        }
    }

    function withdrawMoney(uint256 amount) public {
        if((balances[msg.sender]-amount)>=min_bal)
        {
            if(amnt_fd[msg.sender]>0)
            {
                if((now-time_start[msg.sender])<time_fd)
                {
                    if((balances[msg.sender]-amount)>=amnt_fd[msg.sender])
                    {
                    balances[msg.sender] = balances[msg.sender]-amount;
                    }
                }
                else
                {
                    balances[msg.sender] = balances[msg.sender]-amount;
                }
            }
        }
    }

    function deleteAccount() public {
        delete balances[msg.sender];
    }

    function fixedDeposit(uint256 amount) public
    {
        amnt_fd[msg.sender] = amount;
        time_start[msg.sender] = now;
    }

    function depositFund(uint256 deposit, address depositor) public {
        balances[depositor]+=deposit;
    }


    //code for Joint Account

    function makeJointAccount(address ja1, address ja2, uint256 bal) public {
        if(bal>=min_bal)
        {
            joint[ja1] = ja2;
            jBalance[ja1] = bal;
        }
    }

    function delJointAccount(address ja1) public {
        delete joint[ja1];
        delete jBalance[ja1];
    }

    function jWithdrawMoney(uint256 amount) public {
        if((balances[msg.sender]-amount)>=min_bal)
        {
                    jBalance[msg.sender] = jBalance[msg.sender]-amount;
        }
    }


}
