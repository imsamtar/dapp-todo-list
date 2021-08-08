<script lang="ts">
  import type Web3Type from "web3/types";
  import type { Contract } from "web3-eth-contract";

  import { onMount } from "svelte";
  import Todo from "./Todo.svelte";
  import _Web3 from "web3/dist/web3.min";
  import todoListAbi, { contractAddress } from "./abi";

  let text = "";
  const Web3: typeof Web3Type = _Web3;
  const web3: Web3Type = new Web3(Web3.givenProvider);
  let contract: Contract;

  let todos: {
    id: string;
    title: string;
    completed: boolean;
    sender: string;
  }[] = [];

  onMount(async () => {
    if (!window["ethereum"]) return;
    await web3.eth.requestAccounts();
    web3.currentProvider["addListener"]("accountsChanged", () => {
      window.location.reload();
    });
    contract = new web3.eth.Contract(todoListAbi as any, contractAddress);

    const accounts = await web3.eth.getAccounts();
    contract.events.TodoAdded(async (error, event) => {
      if (!error) {
        const { id, sender } = event.returnValues || {};
        if (sender === accounts[0]) {
          const [, title, completed, sender] = await contract.methods
            .getMyTodo(id)
            .call({ from: accounts[0] });

          todos = todos.concat([{ id, title, completed, sender }]);
          //   console.log(todos);
        }
      }
    });
    fetchTodos(accounts[0]);
  });

  async function fetchTodos(account) {
    const list = await contract.methods.getMyTodos().call({ from: account });
    const _todos = list.map(([id, title, completed, sender]) => ({
      id,
      title,
      completed,
      sender,
    }));
    todos = _todos;
  }

  async function addTodo() {
    const accounts = await web3.eth.getAccounts();
    const result = await contract.methods
      .addTodo(text)
      .send({ from: accounts[0] });
    console.log(result);
    text = "";
  }
</script>

<main>
  {#if web3.currentProvider}
    <Todo bind:text on:submit={addTodo} />
    {#each todos.sort((a, b) => parseInt(a.id) - parseInt(b.id)) as todo}
      <Todo text={todo.title} />
    {/each}
  {/if}
</main>

<style>
  main {
    text-align: center;
    padding: 0;
    max-width: 240px;
    margin: 0 auto;
    background: #333333;
    height: 100%;
    padding: 3rem;
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>
