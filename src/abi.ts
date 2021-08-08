import artifect from "../build/contracts/TodoList.json";

const todoListAbi = artifect.abi;

export default todoListAbi;
export const contractAddress = artifect.networks[5777].address;
