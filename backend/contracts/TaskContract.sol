// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract TaskContract {
  event AddTask(address indexed recipient, uint indexed taskId);
  event DeleteTask(uint indexed taskId, bool isDeleted);

  struct Task {
    uint id;
    string taskText;
    bool isDeleted;
  }

  Task[] private tasks;
  mapping(uint => address) private taskToOwner;

  function addTask(string memory taskText, bool isDeleted) external {
    uint taskId = tasks.length;
    tasks.push(Task(taskId, taskText, isDeleted));
    taskToOwner[taskId] = msg.sender;
    emit AddTask(msg.sender, taskId);
  }

  function getMyTasks() external view returns (Task[] memory) {
    uint counter = 0;
    for (uint i = 0; i < tasks.length; i++) {
      if (taskToOwner[i] == msg.sender && !tasks[i].isDeleted) {
        counter++;
      }
    }
    Task[] memory result = new Task[](counter);
    counter = 0;
    for (uint i = 0; i < tasks.length; i++) {
      if (taskToOwner[i] == msg.sender && !tasks[i].isDeleted) {
        result[counter] = tasks[i];
        counter++;
      }
    }
    return result;
  }

  function deleteTask(uint taskId) external {
    require(taskToOwner[taskId] == msg.sender, "You are not the owner of this task");
    tasks[taskId].isDeleted = true;
    emit DeleteTask(taskId, true);
  }
}
