const resource = "tpf";
window.addEventListener("message", (event) => {
  const data = event.data;
  let container = document.getElementById("container");

  if (data.type === "openspawn") {
    container.style.display = "flex";
    var characters = data.data;
    for (var i = 0; i < characters.length; i++) {
      var character = characters[i];
      var ci = character.cindex;

      if (character) {
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

        var spawnCharacterBtn = document.getElementById("spawn-character");
        if (character.new == true) {
          spawnCharacterBtn.dataset.new = "true";
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
  let spawnmenuCancelBtn = document.getElementById("spawnmenu-exit");
  spawnmenuCancelBtn.addEventListener("click", () => {
    axios.post(`https://${resource}/closeSpawnmenu`, {});
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
