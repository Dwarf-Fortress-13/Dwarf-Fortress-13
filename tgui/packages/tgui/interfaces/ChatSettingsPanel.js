import { Button, Section } from '../components';

import { Window } from '../layouts';
import { useBackend } from '../backend';

export const ChatSettingsPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const ghostPreSort = data.ghost || [];
  const ghost = ghostPreSort.sort((a, b) => {
    const descA = a.desc.toLowerCase();
    const descB = b.desc.toLowerCase();
    if (descA < descB) {
      return -1;
    }
    if (descA > descB) {
      return 1;
    }
    return 0;
  });
  const icPreSort = data.ic || [];
  const ic = icPreSort.sort((a, b) => {
    const descA = a.desc.toLowerCase();
    const descB = b.desc.toLowerCase();
    if (descA < descB) {
      return -1;
    }
    if (descA > descB) {
      return 1;
    }
    return 0;
  });
  const chatPreSort = data.chat || [];
  const chat = chatPreSort.sort((a, b) => {
    const descA = a.desc.toLowerCase();
    const descB = b.desc.toLowerCase();
    if (descA < descB) {
      return -1;
    }
    if (descA > descB) {
      return 1;
    }
    return 0;
  });
  return (
    <Window
      title="Chat Settings"
      width={250}
      height={460}>
      <Window.Content scrollable>
        <Section title="Main">
          {chat.map(a => (
            <Button
              fluid
              key={a.key}
              icon={a.enabled ? 'times' : 'check'}
              content={a.desc}
              color={a.enabled ? 'bad' : 'good'}
              onClick={() => act(a.type, { key: a.key })} />
          ))}
        </Section>
        <Section title="IC">
          {ic.map(a => (
            <Button
              fluid
              key={a.key}
              icon={a.enabled ? 'times' : 'check'}
              content={a.desc}
              color={a.enabled ? 'bad' : 'good'}
              onClick={() => act(a.type, { key: a.key })} />
          ))}
        </Section>
        <Section title="Ghost">
          {ghost.map(a => (
            <Button
              fluid
              key={a.key}
              icon={a.enabled ? 'times' : 'check'}
              content={a.desc}
              color={a.enabled ? 'bad' : 'good'}
              onClick={() => act(a.type, { key: a.key })} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
