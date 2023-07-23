// ECONOMY Functions

const propertyOrder = ["id", "money", "type", "reciver", "date"];
function createTransactionElement(transaction) {
  const transactionElement = document.createElement("div");
  transactionElement.classList.add("transaction");
  transactionElement.id = transaction.id;

  propertyOrder.forEach((key) => {
    const dataElement = document.createElement("div");
    dataElement.classList.add("transaction-data");
    dataElement.id = key;
    dataElement.textContent = transaction[key];
    transactionElement.appendChild(dataElement);
  });

  return transactionElement;
}

function showTransactions(transactions) {
  const transactionsContainer = document.getElementById(
    "transactions-container"
  );

  transactionsContainer.innerHTML = "";

  if (transactions.length === 0) {
    const noTransactionsElement = document.createElement("div");
    noTransactionsElement.classList.add("no-transactions");
    noTransactionsElement.textContent = "Inga transaktioner har gjorts.";
    transactionsContainer.appendChild(noTransactionsElement);
  } else {
    transactions.forEach((transaction) => {
      const transactionElement = createTransactionElement(transaction);
      transactionsContainer.appendChild(transactionElement);
    });
  }
}

// Global

const resource = "tpf";
window.addEventListener("message", (event) => {
  const data = event.data;

  // Economy

  var bank = document.getElementById("bank-balance");
  var cash = document.getElementById("cash-balance");

  if (data.type == "openATM") {
    bank.style.display = "none";
    cash.style.display = "none";

    const bankContainer = document.querySelector(".bank-container");
    bankContainer.style.display = "block";

    var firstname = data.account.firstname;
    var lastname = data.account.lastname;

    showTransactions(data.account.transactions);

    const availableBalance = document.getElementById("available-balance");
    availableBalance.textContent = data.account.balance + " KR";

    const transactionIdElement = document.getElementById("transaction-id");
    transactionIdElement.textContent = data.account.id;

    const welcomeMessage = document.getElementById("welcome-user");
    welcomeMessage.textContent = "Välkommen " + firstname + " " + lastname;
  }

  if (data.type == "closeATM") {
    location.reload();
    const bankContainer = document.querySelector(".bank-container");
    bankContainer.style.display = "none";
    bank.style.display = "none";
    cash.style.display = "none";
  }

  if (data.type == "updateMoney") {
    bank.textContent = "SEK " + data.bank;
    cash.textContent = "SEK " + data.cash;
  }

  // Spawnmenu

  let container = document.getElementById("container");

  if (data.type === "openspawn") {
    container.style.display = "flex";
    var characters = data.data;
    for (var i = 0; i < characters.length; i++) {
      var character = characters[i];
      var ci = character.cindex;

      if (character.cindex) {
        var characterName = document.querySelector(
          `#character-${ci} #character-name`
        );
        var characterAge = document.querySelector(
          `#character-${ci} #character-age`
        );
        var characterGender = document.querySelector(
          `#character-${ci} #character-gender`
        );
        var characterJob = document.querySelector(
          `#character-${ci} #character-job`
        );
        var spawnBtn = document.querySelector(
          `#character-${ci} #spawn-character`
        );
        var deleteBtn = document.querySelector(
          `#character-${ci} #delete-character`
        );
        var createBtn = document.querySelector(
          `#character-${ci} #create-character`
        );
        var activeBtn = document.querySelector(
          `#character-${ci} #active-character`
        );

        characterName.textContent =
          character.firstname + " " + character.lastname;
        characterAge.textContent = character.age;
        let gender = character.gender;
        if (gender == "male") {
          gender = "Man";
        } else {
          gender = "Kvinna";
        }
        characterGender.textContent = gender;
        let job = character.job;
        if (job == "unemployed") {
          job = "Arbetslös";
        }
        characterJob.textContent = job;

        createBtn.style.display = "none";

        if (character.active) {
          activeBtn.style.display = "block";
        } else {
          spawnBtn.style.display = "block";
          deleteBtn.style.display = "block";
        }

        if (character.new == true) {
          spawnBtn.dataset.new = "true";
        }
      }
    }
    let spawnmenuCancelBtn = document.getElementById("spawnmenu-exit");
    if (data.init) {
      spawnmenuCancelBtn.style.display = "none";
    } else {
      spawnmenuCancelBtn.style.display = "block";
    }
  }
  if (data.type === "closespawn") {
    container.style.display = "none";
  }
});

document.addEventListener("DOMContentLoaded", () => {
  // Economy
  const exitSveaBank = document.getElementById("exit-bank");
  exitSveaBank.addEventListener("click", () => {
    axios.post(`https://${resource}/closeATM`).then((response) => {
      location.reload();
      const bankContainer = document.querySelector(".bank-container");
      bankContainer.style.display = "none";
    });
  });

  const sendTransactionMessage = document.getElementById("transaction-send");
  sendTransactionMessage.addEventListener("click", (e) => {
    e.preventDefault();
    let firstnameInput = document.getElementById("reciver-firstname");
    let lastnameInput = document.getElementById("reciver-lastname");
    let transactionIdInput = document.getElementById("reciver-id");
    let amountInput = document.getElementById("transaction-amount");
    let noteInput = document.getElementById("transaction-note");

    let firstname = firstnameInput.value;
    let lastname = lastnameInput.value;
    let transactionId = transactionIdInput.value;
    let amount = amountInput.value.trim();
    let note = noteInput.value;
    if (!firstname) {
      firstnameInput.focus();
      return;
    }
    if (!lastname) {
      lastnameInput.focus();
      return;
    }
    if (!transactionId) {
      transactionIdInput.focus();
      return;
    }
    if (!amount) {
      amountInput.focus();
      return;
    }

    const validAmountRegex = /^\d+(\.\d{1,2})?$/;

    if (validAmountRegex.test(amount)) {
      amount = parseFloat(amount);
    } else {
      alert(`"` + amount + `" är inte ett gilltigt belopp.`);
      amountInput.focus();
      return;
    }

    if (!note) {
      note = "Ingen Anteckning";
    }

    const newTransaction = {
      firstname: firstname,
      lastname: lastname,
      transactionId: transactionId,
      amount: amount,
      note: note,
    };

    axios.post(`https://${resource}/sendTransaction`, {
      transaction: newTransaction,
    });
  });

  const withdrawMoney = document.querySelector(".withdraw-btn");
  if (withdrawMoney) {
    withdrawMoney.addEventListener("click", () => {
      let amountInput = document.querySelector(".withdraw-amount");
      let amount = amountInput.value.trim();
      if (!amount) {
        amountInput.focus();
        return;
      }

      const validAmountRegex = /^\d+(\.\d{1,2})?$/;

      if (validAmountRegex.test(amount)) {
        amount = parseFloat(amount);
      } else {
        alert(`"` + amount + `" är inte ett gilltigt belopp.`);
        amountInput.focus();
        return;
      }

      axios.post(`https://${resource}/withdrawMoney`, { amount: amount });
    });
  }

  const depositMoney = document.querySelector(".deposit-btn");
  if (depositMoney) {
    depositMoney.addEventListener("click", () => {
      let amountInput = document.querySelector(".deposit-amount");
      let amount = amountInput.value.trim();
      if (!amount) {
        amountInput.focus();
        return;
      }

      const validAmountRegex = /^\d+(\.\d{1,2})?$/;

      if (validAmountRegex.test(amount)) {
        amount = parseFloat(amount);
      } else {
        alert(`"` + amount + `" är inte ett gilltigt belopp.`);
        amountInput.focus();
        return;
      }

      axios.post(`https://${resource}/depositMoney`, { amount: amount });
    });
  }

  // Spawnmenu

  let spawnmenuCancelBtn = document.getElementById("spawnmenu-exit");
  spawnmenuCancelBtn.addEventListener("click", () => {
    if (spawnmenuCancelBtn.textContent == "Avbryt") {
      axios.post(`https://${resource}/closeSpawnmenu`, {});
    } else if ((spawnmenuCancelBtn.textContent = "Tillbaka")) {
      var characterDivs = document.querySelectorAll(".character");
      characterDivs.forEach((character) => {
        character.style.display = "flex";
        var spawnLocationDiv = document.getElementById("spawning-locations");
        spawnLocationDiv.style.display = "none";
      });
      spawnmenuCancelBtn.textContent = "Avbryt";
    }
  });

  var spawnBtns = document.querySelectorAll(`#spawn-character`);
  var deleteBtns = document.querySelectorAll(`#delete-character`);
  var createBtns = document.querySelectorAll(`#create-character`);
  var confirmDeleteBtns = document.querySelectorAll(
    `#delete-character-confirm`
  );
  var abortDeleteBtns = document.querySelectorAll(`#delete-character-abort`);

  spawnBtns.forEach((spawnBtn) => {
    spawnBtn.addEventListener("click", () => {
      var parentDiv = spawnBtn.closest(".character").id;
      var cid = parentDiv.substring("character-".length);

      if (spawnBtn.dataset.new == "true") {
        selectedLocation = "default";
        axios
          .post(`https://${resource}/spawnChar`, {
            cid: cid,
            location: selectedLocation,
          })
          .then((response) => {
            location.reload();
          });
      }

      var characterDivs = document.querySelectorAll(".character");
      characterDivs.forEach((character) => {
        character.style.display = "none";
        var spawnLocationDiv = document.getElementById("spawning-locations");
        spawnLocationDiv.dataset.cid = cid;
        spawnLocationDiv.style.display = "flex";
      });

      spawnmenuCancelBtn.textContent = "Tillbaka";
    });
  });
  deleteBtns.forEach((deleteBtn, i) => {
    deleteBtn.addEventListener("click", () => {
      deleteBtn.style.display = "none";
      spawnBtns[i].style.display = "none";
      confirmDeleteBtns[i].style.display = "block";
      abortDeleteBtns[i].style.display = "block";
    });
  });
  abortDeleteBtns.forEach((abortDeleteBtn, i) => {
    abortDeleteBtn.addEventListener("click", () => {
      deleteBtns[i].style.display = "block";
      spawnBtns[i].style.display = "block";
      confirmDeleteBtns[i].style.display = "none";
      abortDeleteBtn.style.display = "none";
    });
  });
  confirmDeleteBtns.forEach((confirmDeleteBtn, i) => {
    confirmDeleteBtn.addEventListener("click", () => {
      var parentDiv = confirmDeleteBtn.closest(".character");
      var cid = parentDiv.id.substring("character-".length);
      axios
        .post(`https://${resource}/deleteChar`, {
          cid: cid,
        })
        .then((response) => {
          deleteBtns[i].style.display = "block";
          spawnBtns[i].style.display = "block";
          confirmDeleteBtn.style.display = "none";
          abortDeleteBtns[i].style.display = "none";
          location.reload();
        });
    });
  });

  createBtns.forEach((createBtn) => {
    createBtn.addEventListener("click", () => {
      var parentDiv = createBtn.closest(".character").id;
      var cid = parentDiv.substring("character-".length);
      var characterDivs = document.querySelectorAll(".character");
      characterDivs.forEach((characterDiv) => {
        characterDiv.style.display = "none";
      });
      var createCharacterDiv = document.querySelector(".create-character");
      createCharacterDiv.style.display = "flex";
      var cindexInput = document.getElementById("cindex");
      cindexInput.value = cid;
    });
  });

  var confirmCreateBtn = document.getElementById("confirm-create");
  if (confirmCreateBtn) {
    confirmCreateBtn.addEventListener("click", (e) => {
      var firstname = document.getElementById("firstname").value;
      var lastname = document.getElementById("lastname").value;
      var dob = document.getElementById("dob-input").value;
      var gender = document.getElementById("gender-select").value;
      var cindex = document.getElementById("cindex").value;

      if (!firstname) {
        return;
      }
      if (!lastname) {
        return;
      }
      if (!dob) {
        return;
      }
      if (!gender) {
        return;
      }
      if (!cindex) {
        console.log("ERR: Cindex inte difinerat. Kontakta Tuggummi/Ägaren.");
        return;
      }

      let age = calculateAge(dob);

      const charData = {
        firstname,
        lastname,
        age,
        dob,
        gender,
        cindex,
      };

      var characterDivs = document.querySelectorAll(".character");
      characterDivs.forEach((characterDiv) => {
        characterDiv.style.display = "flex";
      });
      var createCharacterDiv = document.querySelector(".create-character");
      createCharacterDiv.style.display = "none";

      axios
        .post(`https://${resource}/createChar`, {
          data: charData,
        })
        .then((response) => {
          location.reload();
        });
    });

    var spawningLocations = document.querySelector("#spawning-locations");
    var spawnBtn = document.getElementById("spawnBtn");

    if (spawningLocations) {
      var spawnLocations = document.querySelectorAll(".spawnLocation");
      spawnLocations.forEach((spawnLocation, i) => {
        spawnLocation.addEventListener("click", () => {
          if (spawnLocation.classList.contains("selected")) {
            spawnLocation.classList.remove("selected");
            if (!spawnBtn.classList.contains("nothing-selected")) {
              spawnBtn.classList.add("nothing-selected");
            }
            return;
          }
          alreadySelected = document.querySelector(".selected");
          if (alreadySelected) {
            alreadySelected.classList.remove("selected");
          }
          if (spawnBtn.classList.contains("nothing-selected")) {
            spawnBtn.classList.remove("nothing-selected");
          }
          spawnLocation.classList.add("selected");
        });
      });
      spawnBtn.addEventListener("click", () => {
        cid = document.getElementById("spawning-locations").dataset.cid;
        selectedLocation = document.querySelector(".selected").id;
        axios
          .post(`https://${resource}/spawnChar`, {
            cid: cid,
            location: selectedLocation,
          })
          .then((response) => {
            location.reload();
          });
      });
    }
  }

  var abortCreateBtn = document.getElementById("abort-create");
  if (abortCreateBtn) {
    abortCreateBtn.addEventListener("click", () => {
      var characterDivs = document.querySelectorAll(".character");
      characterDivs.forEach((characterDiv) => {
        characterDiv.style.display = "flex";
      });
      var createCharacterDiv = document.querySelector(".create-character");
      createCharacterDiv.style.display = "none";
    });
  }
});

function calculateAge(dob) {
  const dobDate = new Date(dob);
  const currentDate = new Date();

  let age = currentDate.getFullYear() - dobDate.getFullYear();

  const hasBirthdayOccurred =
    currentDate.getMonth() > dobDate.getMonth() ||
    (currentDate.getMonth() === dobDate.getMonth() &&
      currentDate.getDate() >= dobDate.getDate());

  if (!hasBirthdayOccurred) {
    age--;
  }

  return age;
}
