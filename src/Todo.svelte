<script lang="ts">
  export let text = "";
</script>

<form class="todo" on:submit|preventDefault>
  <input type="text" bind:value={text} />
  <button type="submit">X</button>
</form>

<style>
  .todo {
    display: flex;
    gap: 1rem;
  }
  input {
    width: 100%;
  }
  button,
  input {
    padding: 0.5rem 1rem;
    font-size: 1.2rem;
    border: none;
    outline: none;
    background: #ffffff55;
    color: white;
  }
</style>
