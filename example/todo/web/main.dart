import 'package:ui/ui.dart';

enum Status { todo, inProgress, done }

class Item {
  String text;
  Status status;
  Item(this.text, this.status);
}

void main() {
  List<Item> items = [
    Item("Task 1", Status.todo),
    Item("Task 2", Status.inProgress),
    Item("Task 3", Status.done),
    Item("Task 4", Status.todo),
    Item("Task 5", Status.inProgress),
  ];

  final inputRef = InputRef();

  Item? selectedItem;
  bool showModal = false;
  App(
    children: [
      Theme(
        styles: {
          'container': Style("container", {
            Breakpoint.base: StyleBlock(
              styles: {
                Css.backgroundColor: '#F4F5F7', // Jira light gray background
                Css.maxHeight: '100vh',
                Css.minHeight: '100vh',
                Css.display: 'flex',
                Css.flexDirection: 'column',
              },
            ),
            Breakpoint.sm: StyleBlock(
              styles: {
                Css.backgroundColor: '#F4F5F7',
                Css.maxHeight: '100vh',
                Css.minHeight: '100vh',
                Css.display: 'flex',
                Css.flexDirection: 'column',
              },
            ),
          }),
          'todo-card': Style("todo-card", {
            Breakpoint.base: StyleBlock(
              styles: {
                Css.backgroundColor: 'white',
                Css.borderRadius: '4px',
                Css.boxShadow: '0 1px 2px rgba(0, 0, 0, 0.1)',
                Css.padding: '12px',
                Css.margin: '8px',
                Css.border: '1px solid #DFE1E6', // Jira card border
              },
              states: {
                PseudoState.hover: {
                  Css.boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)',
                },
              },
            ),
            Breakpoint.sm: StyleBlock(
              styles: {
                Css.backgroundColor: 'white',
                Css.borderRadius: '4px',
                Css.boxShadow: '0 1px 2px rgba(0, 0, 0, 0.1)',
                Css.padding: '8px',
                Css.margin: '6px',
                Css.border: '1px solid #DFE1E6',
              },
            ),
          }),
        },
        builder: (state) {
          return Container(
            style: state.getStyle('container'),
            children: [
              // Modal
              if (showModal)
                Container(
                  style: Style('modal', {
                    Breakpoint.base: StyleBlock(
                      styles: {
                        Css.position: 'fixed',
                        Css.top: '50%',
                        Css.left: '50%',
                        Css.transform: 'translate(-50%, -50%)',
                        Css.backgroundColor: 'white',
                        Css.boxShadow: '0 4px 8px rgba(0, 0, 0, 0.2)',
                        Css.borderRadius: '8px',
                        Css.zIndex: '1000',
                        Css.width: '300px',
                        Css.padding: '16px',
                        Css.display: 'flex',
                        Css.flexDirection: 'column',
                        Css.gap: '12px',
                      },
                    ),
                  }),
                  children: [
                    // move to either inProgress or Done
                    if (selectedItem?.status == Status.todo)
                      Container(
                        style: Style('move-task', {
                          Breakpoint.base: StyleBlock(
                            styles: {
                              Css.display: 'flex',
                              Css.flexDirection: 'column',
                              Css.gap: '12px',
                            },
                          ),
                        }),
                        children: [
                          Text("Move Task: ${selectedItem?.text}"),
                          Button(
                            Text("In Progress?"),
                            className: "button",
                            onClick: (event) {
                              if (selectedItem != null) {
                                selectedItem!.status = Status.inProgress;
                                showModal = false;
                                state.update();
                              }
                            },
                          ),
                        ],
                      ),
                    if (selectedItem?.status == Status.inProgress)
                      Container(
                        className: "move-task",
                        children: [
                          Text("Move Task: ${selectedItem?.text}"),
                          Button(
                            Text("Done?"),
                            className: "button",
                            onClick: (event) {
                              if (selectedItem != null) {
                                selectedItem!.status = Status.done;
                                showModal = false;
                                state.update();
                              }
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              Container(
                style: Style('header', {
                  Breakpoint.base: StyleBlock(
                    styles: {
                      Css.backgroundColor: '#0052CC', // Jira blue
                      Css.color: 'white',
                      Css.padding: '16px',
                      Css.textAlign: 'center',
                      Css.flex: '0 0 auto',
                      Css.fontSize: '20px',
                      Css.fontWeight: 'bold',
                    },
                  ),
                  Breakpoint.sm: StyleBlock(
                    styles: {
                      Css.backgroundColor: '#0052CC',
                      Css.color: 'white',
                      Css.padding: '12px',
                      Css.textAlign: 'center',
                      Css.flex: '0 0 auto',
                      Css.fontSize: '16px',
                      Css.fontWeight: 'bold',
                    },
                  ),
                }),
                children: [Text("Jira-like Task Board")],
              ),
              Container(
                style: Style('main', {
                  Breakpoint.sm: StyleBlock(
                    styles: {
                      Css.display: 'flex',
                      Css.flexDirection: 'column',
                      Css.gap: '12px',
                      Css.flex: '1 1 auto',
                      Css.padding: '12px',
                    },
                  ),
                  Breakpoint.lg: StyleBlock(
                    styles: {
                      Css.display: 'grid',
                      Css.gridTemplateColumns: 'repeat(3, 1fr)',
                      Css.gap: '16px',
                      Css.flex: '1 1 auto',
                      Css.padding: '16px',
                    },
                    states: {
                      PseudoState.hover: {Css.cursor: 'default'},
                    },
                  ),
                }),
                children: [
                  Container(
                    style: Style('todo-column', {
                      Breakpoint.base: StyleBlock(
                        styles: {
                          Css.backgroundColor:
                              '#EBECF0', // Jira column background
                          Css.padding: '12px',
                          Css.borderRadius: '4px',
                        },
                      ),
                      Breakpoint.sm: StyleBlock(
                        styles: {
                          Css.backgroundColor: '#EBECF0',
                          Css.padding: '8px',
                          Css.borderRadius: '4px',
                        },
                      ),
                    }),
                    children: [
                      Text(
                        "To Do",
                        style: Style("text", {
                          Breakpoint.base: StyleBlock(
                            styles: {
                              Css.fontSize: '16px',
                              Css.fontWeight: '600',
                              Css.color: '#172B4D', // Jira dark text
                              Css.marginBottom: '8px',
                            },
                          ),
                          Breakpoint.sm: StyleBlock(
                            styles: {
                              Css.fontSize: '14px',
                              Css.fontWeight: '600',
                              Css.color: '#172B4D',
                              Css.marginBottom: '6px',
                            },
                          ),
                        }),
                      ),
                      for (var item in items.where(
                        (i) => i.status == Status.todo,
                      ))
                        Container(
                          onRender: (box) {
                            box.on(Event.click, (event) {
                              selectedItem = item;
                              showModal = true;
                              state.update();
                            });
                          },
                          style: state.getStyle('todo-card'),
                          children: [Text(item.text)],
                        ),
                      Container(
                        style: Style('input', {
                          Breakpoint.base: StyleBlock(
                            styles: {
                              Css.display: 'flex',
                              Css.gap: '8px',
                              Css.marginTop: '12px',
                              Css.height: '44px',
                            },
                          ),
                          Breakpoint.sm: StyleBlock(
                            styles: {
                              Css.display: 'flex',
                              Css.gap: '6px',
                              Css.marginTop: '8px',
                            },
                          ),
                        }),
                        children: [
                          Input(
                            id: 'new-task-input',
                            ref: inputRef,
                            type: 'text',
                            placeholder: 'Add new task',
                            style: Style('input-field', {
                              Breakpoint.base: StyleBlock(
                                styles: {
                                  Css.padding: '8px',
                                  Css.border: '1px solid #DFE1E6',
                                  Css.borderRadius: '4px',
                                  Css.flex: '1',
                                  Css.margin: "0 8px",
                                },
                              ),
                              Breakpoint.sm: StyleBlock(
                                styles: {
                                  Css.padding: '6px',
                                  Css.border: '1px solid #DFE1E6',
                                  Css.borderRadius: '4px',
                                  Css.flex: '1',
                                },
                              ),
                            }),
                          ),
                          Button(
                            Text("Add"),
                            style: Style('button', {
                              Breakpoint.base: StyleBlock(
                                styles: {
                                  Css.backgroundColor: '#0052CC',
                                  Css.color: 'white',
                                  Css.padding: '8px 16px',
                                  Css.borderRadius: '4px',
                                  Css.border: 'none',
                                },
                                states: {
                                  PseudoState.hover: {
                                    Css.backgroundColor: '#003087',
                                  },
                                },
                              ),
                              Breakpoint.sm: StyleBlock(
                                styles: {
                                  Css.backgroundColor: '#0052CC',
                                  Css.color: 'white',
                                  Css.padding: '6px 12px',
                                  Css.borderRadius: '4px',
                                  Css.border: 'none',
                                },
                              ),
                            }),
                            onClick: (e) {
                              final newText = inputRef.value;
                              if (newText?.isNotEmpty == true) {
                                items.add(Item(newText!, Status.todo));
                                inputRef.value = ''; // Clear input
                                state.update();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    style: Style('in-progress-column', {
                      Breakpoint.base: StyleBlock(
                        styles: {
                          Css.backgroundColor: '#EBECF0',
                          Css.padding: '12px',
                          Css.borderRadius: '4px',
                        },
                      ),
                      Breakpoint.sm: StyleBlock(
                        styles: {
                          Css.backgroundColor: '#EBECF0',
                          Css.padding: '8px',
                          Css.borderRadius: '4px',
                        },
                      ),
                    }),
                    children: [
                      Text(
                        "In Progress",
                        style: Style("text", {
                          Breakpoint.base: StyleBlock(
                            styles: {
                              Css.fontSize: '16px',
                              Css.fontWeight: '600',
                              Css.color: '#172B4D',
                              Css.marginBottom: '8px',
                            },
                          ),
                          Breakpoint.sm: StyleBlock(
                            styles: {
                              Css.fontSize: '14px',
                              Css.fontWeight: '600',
                              Css.color: '#172B4D',
                              Css.marginBottom: '6px',
                            },
                          ),
                        }),
                      ),
                      if (items
                          .where((i) => i.status == Status.inProgress)
                          .isEmpty)
                        Text(
                          "No tasks in progress",
                          style: Style("text", {
                            Breakpoint.base: StyleBlock(
                              styles: {
                                Css.color: '#6B778C', // Jira muted text
                                Css.fontSize: '14px',
                              },
                            ),
                            Breakpoint.sm: StyleBlock(
                              styles: {
                                Css.color: '#6B778C',
                                Css.fontSize: '12px',
                              },
                            ),
                          }),
                        ),
                      for (var item in items.where(
                        (i) => i.status == Status.inProgress,
                      ))
                        Container(
                          style: state.getStyle('todo-card'),
                          onRender: (box) {
                            box.on(Event.click, (event) {
                              selectedItem = item;
                              showModal = true;
                              state.update();
                            });
                          },
                          children: [Text(item.text)],
                        ),
                    ],
                  ),
                  Container(
                    style: Style('done-column', {
                      Breakpoint.base: StyleBlock(
                        styles: {
                          Css.backgroundColor: '#E3FCEF', // Jira green for Done
                          Css.padding: '12px',
                          Css.borderRadius: '4px',
                        },
                      ),
                      Breakpoint.sm: StyleBlock(
                        styles: {
                          Css.backgroundColor: '#E3FCEF',
                          Css.padding: '8px',
                          Css.borderRadius: '4px',
                        },
                      ),
                    }),
                    children: [
                      Text(
                        "Done",
                        style: Style("text", {
                          Breakpoint.base: StyleBlock(
                            styles: {
                              Css.fontSize: '16px',
                              Css.fontWeight: '600',
                              Css.color: '#172B4D',
                              Css.marginBottom: '8px',
                            },
                          ),
                          Breakpoint.sm: StyleBlock(
                            styles: {
                              Css.fontSize: '14px',
                              Css.fontWeight: '600',
                              Css.color: '#172B4D',
                              Css.marginBottom: '6px',
                            },
                          ),
                        }),
                      ),
                      for (var item in items.where(
                        (i) => i.status == Status.done,
                      ))
                        Container(
                          style: state.getStyle('todo-card'),
                          children: [Text(item.text)],
                        ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ],
    beforeRender: () => useFont(fontFamily: "Roboto"),
  ).run(target: '#output', onRender: (box) {});
}
