/*
 * TNAlertPresenceSubscription.j
 *
 * Copyright (C) 2010 Antoine Mercadal <antoine.mercadal@inframonde.eu>
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

/*! @ingroup archipelcore
    Subclass of CPAlert that manages the subscription request.
*/
@implementation TNAlertPresenceSubscription: CPAlert
{
    id              stanza @accessors;
    TNStropheRoster roster @accessors;
}

/*! This method have to be use for the initialization.
    @param aStanza the subscription request TNStropheStanza
    @param aRoster a TNStropheRoster

    @return an
*/
- (id)initWithStanza:(id)aStanza roster:(TNStropheRoster)aRoster
{
    if (self = [super init])
    {
        var contactName = [aStanza getFrom];
        var msg         = contactName + " want ask you subscription. Do you want to add it ?";

        [self setStanza:aStanza];
        [self setRoster:aRoster];

        [self setDelegate:self];
        [self setTitle:@"Presence Subscription"];
        [self setMessageText:msg];
        //[self setWindowStyle:CPHUDBackgroundWindowMask];
        [self addButtonWithTitle:@"Yes"];
        [self addButtonWithTitle:@"No"];
    }

    return self;
}

/*! Delegate of itself. It will, according to the user answer, add or not the
    requester to the roster.
*/
- (void)alertDidEnd:(CPAlert)theAlert returnCode:(int)returnCode
{
    if (returnCode == 0)
    {
        [[self roster] answerAuthorizationRequest:[self stanza] answer:YES];
        // [[TNViewLog sharedLogger] log:@"Authorization request accepted from " + [[self stanza] valueForAttribute:@"from"]];
    }
    else
    {
        [[self roster] answerAuthorizationRequest:[self stanza] answer:NO];
        // [[TNViewLog sharedLogger] log:@"Authorization request rejected from " + [[self stanza] valueForAttribute:@"from"]];
    }

}

@end