// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

// pragma experimental ABIEncoderV2;

contract TodoList {
    uint256 public todoCount = 0;

    struct Todo {
        uint256 id;
        string title;
        bool completed;
        address sender;
    }

    mapping(uint256 => Todo) private todos;

    event TodoAdded(uint256 id, address sender);

    function addTodo(string memory title) public {
        uint256 id = todoCount;
        todoCount++;
        todos[id] = Todo(id, title, false, msg.sender);
        emit TodoAdded(id, msg.sender);
    }

    function getMyTodo(uint256 id) public view returns (Todo memory todo) {
        if (todos[id].sender == msg.sender) {
            return todos[id];
        }
    }

    function getMyTodos() public view returns (Todo[] memory filteredTodos) {
        Todo[] memory matchedTodos = new Todo[](todoCount);
        uint256 count = 0;
        for (uint256 id = 0; id < todoCount; id++) {
            if (todos[id].sender == msg.sender) {
                matchedTodos[count] = todos[id];
                count++;
            }
        }
        filteredTodos = new Todo[](count);
        for (uint256 i = 0; i < count; i++) {
            filteredTodos[i] = matchedTodos[i];
        }
        return filteredTodos;
    }
}
