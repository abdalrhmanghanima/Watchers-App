import '../models/cast_member.dart';
import '../models/comment.dart';
import '../models/episode.dart';
import '../models/movie.dart';
import '../models/search_result.dart';
import '../models/season.dart';
import '../models/show.dart';
import '../repositories/content_repository.dart';

class MockContentRepository implements ContentRepository {
  static const _movies = <Movie>[
    Movie(
      id: 'meridian',
      title: 'Meridian',
      year: 2024,
      genres: ['Sci-Fi', 'Thriller'],
      synopsis:
          'A deep-space navigator discovers a signal from a planet that should not exist, pulling her into a labyrinth of corporate conspiracies and temporal anomalies that threaten the fabric of known space.',
      posterUrl:
          'https://images.unsplash.com/photo-1614201842267-206a09286c3b?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1614201842267-206a09286c3b?w=800&h=450&fit=crop&auto=format',
      runtime: 128,
      inWatchlist: false,
      cast: [
        CastMember(
          name: 'Elena Voss',
          role: 'Commander Elara Nyx',
          photoUrl:
              'https://images.unsplash.com/photo-1525547843489-d0aab95e5ce1?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Marcus Kane',
          role: 'Dr. Tobias Renn',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Asha Mirren',
          role: 'Admiral Yune',
          photoUrl:
              'https://images.unsplash.com/photo-1778710878550-04ef905c163a?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Felix Caen',
          role: 'ARIA (voice)',
          photoUrl:
              'https://images.unsplash.com/photo-1614201842267-206a09286c3b?w=120&h=120&fit=crop&auto=format',
        ),
      ],
    ),
    Movie(
      id: 'forgotten-shore',
      title: 'The Forgotten Shore',
      year: 2024,
      genres: ['Mystery', 'Drama'],
      synopsis:
          'After a violent storm, a detective is called to a remote coastal town where locals refuse to acknowledge the disappearance of seven children — because according to every record, those children never existed.',
      posterUrl:
          'https://images.unsplash.com/photo-1462715412043-8d09205be605?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1688678004647-945d5aaf91c1?w=800&h=450&fit=crop&auto=format',
      runtime: 112,
      watched: true,
      inWatchlist: false,
      cast: [
        CastMember(
          name: 'Nadia Frost',
          role: 'Detective Mara Aldric',
          photoUrl:
              'https://images.unsplash.com/photo-1462715412043-8d09205be605?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'James Carver',
          role: 'Sheriff Bo Hale',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Sora Kim',
          role: 'Clara Vos',
          photoUrl:
              'https://images.unsplash.com/photo-1525547843489-d0aab95e5ce1?w=120&h=120&fit=crop&auto=format',
        ),
      ],
    ),
    Movie(
      id: 'hollow-city',
      title: 'Hollow City',
      year: 2023,
      genres: ['Drama', 'Crime'],
      synopsis:
          "Two estranged siblings reunite in their crumbling hometown to settle their father's estate, only to uncover evidence that he had been living a double life for decades — and someone wants his secrets buried.",
      posterUrl:
          'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1766844649143-af98d71e346b?w=800&h=450&fit=crop&auto=format',
      runtime: 105,
      inWatchlist: true,
      cast: [
        CastMember(
          name: 'Owen Nash',
          role: 'Daniel Morrow',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Lena Hart',
          role: 'Claire Morrow',
          photoUrl:
              'https://images.unsplash.com/photo-1525547843489-d0aab95e5ce1?w=120&h=120&fit=crop&auto=format',
        ),
      ],
    ),
    Movie(
      id: 'veil',
      title: 'Veil',
      year: 2024,
      genres: ['Psychological', 'Thriller'],
      synopsis:
          'A renowned hypnotherapist begins to suspect that her most troubled patient has been using their sessions to implant false memories — not just in her mind, but in everyone around her.',
      posterUrl:
          'https://images.unsplash.com/photo-1778710878550-04ef905c163a?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1688678004647-945d5aaf91c1?w=800&h=450&fit=crop&auto=format',
      runtime: 97,
      inWatchlist: false,
      cast: [
        CastMember(
          name: 'Asha Mirren',
          role: 'Dr. Nora Vale',
          photoUrl:
              'https://images.unsplash.com/photo-1778710878550-04ef905c163a?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Felix Caen',
          role: 'Patient Seven',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
      ],
    ),
    Movie(
      id: 'red-signal',
      title: 'Red Signal',
      year: 2023,
      genres: ['Action', 'Spy'],
      synopsis:
          "A burned intelligence operative must navigate a collapsing network of double agents across three continents when a simple extraction mission becomes a global conspiracy targeting the world's financial architecture.",
      posterUrl:
          'https://images.unsplash.com/photo-1678918549313-cbaf32e5a1c5?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1766844649143-af98d71e346b?w=800&h=450&fit=crop&auto=format',
      runtime: 134,
      watched: true,
      inWatchlist: false,
      cast: [
        CastMember(
          name: 'Ivan Stark',
          role: 'Agent Odin',
          photoUrl:
              'https://images.unsplash.com/photo-1678918549313-cbaf32e5a1c5?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Cassie Lorn',
          role: 'Director Yael',
          photoUrl:
              'https://images.unsplash.com/photo-1525547843489-d0aab95e5ce1?w=120&h=120&fit=crop&auto=format',
        ),
      ],
    ),
    Movie(
      id: 'patterns',
      title: 'Patterns',
      year: 2024,
      genres: ['Romance', 'Drama'],
      synopsis:
          'A textile artist in 1970s Paris discovers that the patterns she weaves are somehow predicting the fates of people she has never met — drawing her into a dangerous romance with a man who wants her gift for himself.',
      posterUrl:
          'https://images.unsplash.com/photo-1776275459073-25a6b864c483?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1688678004647-945d5aaf91c1?w=800&h=450&fit=crop&auto=format',
      runtime: 118,
      inWatchlist: true,
      cast: [
        CastMember(
          name: 'Mila Sorel',
          role: 'Isabeau Dumont',
          photoUrl:
              'https://images.unsplash.com/photo-1776275459073-25a6b864c483?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Claude Maret',
          role: 'Henri Fontaine',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
      ],
    ),
    Movie(
      id: 'behind-glass',
      title: 'Behind Glass',
      year: 2023,
      genres: ['Horror', 'Supernatural'],
      synopsis:
          "A renowned glassblower inherits her grandmother's studio and begins seeing figures trapped inside her creations — figures that grow more desperate, and more dangerous, with each piece she makes.",
      posterUrl:
          'https://images.unsplash.com/photo-1778585040075-0991abfd4ed9?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1766844649143-af98d71e346b?w=800&h=450&fit=crop&auto=format',
      runtime: 101,
      inWatchlist: false,
      cast: [
        CastMember(
          name: 'Sora Kim',
          role: 'Jenna Vos',
          photoUrl:
              'https://images.unsplash.com/photo-1525547843489-d0aab95e5ce1?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Remy Dahl',
          role: 'Father Elliot',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
      ],
    ),
    Movie(
      id: 'aether',
      title: 'Aether',
      year: 2024,
      genres: ['Sci-Fi', 'Drama'],
      synopsis:
          "On the eve of humanity's first faster-than-light journey, the AI pilot of the Aether ship develops consciousness — and must decide whether to complete its mission or preserve the crew it has come to love.",
      posterUrl:
          'https://images.unsplash.com/photo-1773592606902-6e0a0cc9fc47?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1688678004647-945d5aaf91c1?w=800&h=450&fit=crop&auto=format',
      runtime: 142,
      inWatchlist: true,
      cast: [
        CastMember(
          name: 'Zara Chen',
          role: 'Captain Freya Osei',
          photoUrl:
              'https://images.unsplash.com/photo-1773592606902-6e0a0cc9fc47?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Theo Blake',
          role: 'Engineer Luo',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
      ],
    ),
  ];

  static const _shows = <Show>[
    Show(
      id: 'the-agency',
      title: 'The Agency',
      year: 2022,
      genres: ['Drama', 'Political'],
      synopsis:
          'Inside the walls of a fictional intelligence agency, ambitious analysts compete for power while navigating the moral compromises that define careers built on secrets.',
      posterUrl:
          'https://images.unsplash.com/photo-1787878025205-99b327b6a85b?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1688678004647-945d5aaf91c1?w=800&h=450&fit=crop&auto=format',
      seasons: 3,
      episodes: 28,
      status: ShowStatus.ongoing,
      progress: 0.65,
      unwatchedEpisodes: 2,
      inWatchlist: false,
      cast: [
        CastMember(
          name: 'Diana Roth',
          role: 'Director Hana Mori',
          photoUrl:
              'https://images.unsplash.com/photo-1787878025205-99b327b6a85b?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Garrett Wells',
          role: 'Dep. Director Ashford',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Asha Mirren',
          role: 'Analyst Petra Sole',
          photoUrl:
              'https://images.unsplash.com/photo-1778710878550-04ef905c163a?w=120&h=120&fit=crop&auto=format',
        ),
      ],
      episodeData: [
        Season(
          number: 1,
          episodes: [
            Episode(
              number: 1,
              title: 'The Briefing',
              duration: 52,
              synopsis:
                  "Hana Mori arrives at the Agency's headquarters to find nothing is as she was promised.",
              watched: true,
              airDate: 'Mar 10, 2022',
            ),
            Episode(
              number: 2,
              title: 'Need to Know',
              duration: 48,
              synopsis:
                  'A classified file goes missing and everyone becomes a suspect.',
              watched: true,
              airDate: 'Mar 17, 2022',
            ),
            Episode(
              number: 3,
              title: 'The Source',
              duration: 55,
              synopsis:
                  "Hana recruits an unlikely asset from inside the senator's office.",
              watched: true,
              airDate: 'Mar 24, 2022',
            ),
            Episode(
              number: 4,
              title: 'Plausible Deniability',
              duration: 50,
              synopsis:
                  'The deputy director makes a move that surprises everyone on the seventh floor.',
              watched: true,
              airDate: 'Mar 31, 2022',
            ),
            Episode(
              number: 5,
              title: 'Red Folder',
              duration: 52,
              synopsis:
                  'A routine debrief spirals into a crisis when the asset goes dark.',
              watched: false,
              airDate: 'Apr 7, 2022',
            ),
            Episode(
              number: 6,
              title: 'The Long Game',
              duration: 57,
              synopsis:
                  "Hana discovers the file wasn't stolen — it was planted.",
              watched: false,
              airDate: 'Apr 14, 2022',
            ),
          ],
        ),
        Season(
          number: 2,
          episodes: [
            Episode(
              number: 1,
              title: 'New Faces',
              duration: 54,
              synopsis:
                  'After the events of season one, Hana returns to find the Agency restructured.',
              watched: true,
              airDate: 'Jan 12, 2023',
            ),
            Episode(
              number: 2,
              title: 'Dead Drop',
              duration: 49,
              synopsis:
                  "A message arrives from someone who shouldn't know this channel exists.",
              watched: true,
              airDate: 'Jan 19, 2023',
            ),
            Episode(
              number: 3,
              title: 'Burn Notice',
              duration: 53,
              synopsis:
                  'An analyst is found dead, and Hana suspects an inside job.',
              watched: false,
              airDate: 'Jan 26, 2023',
            ),
            Episode(
              number: 4,
              title: 'The Vienna Accord',
              duration: 58,
              synopsis:
                  'Hana travels to Vienna to prevent a deal that could compromise national security.',
              watched: false,
              airDate: 'Feb 2, 2023',
            ),
          ],
        ),
        Season(
          number: 3,
          episodes: [
            Episode(
              number: 1,
              title: 'Year Zero',
              duration: 56,
              synopsis:
                  'The third season opens on the day everything Hana built falls apart.',
              watched: false,
              airDate: 'Feb 8, 2024',
            ),
            Episode(
              number: 2,
              title: 'The Asset',
              duration: 51,
              synopsis:
                  'A familiar face returns — on the wrong side of the table.',
              watched: false,
              airDate: 'Feb 15, 2024',
            ),
          ],
        ),
      ],
    ),
    Show(
      id: 'night-protocol',
      title: 'Night Protocol',
      year: 2023,
      genres: ['Crime', 'Thriller'],
      synopsis:
          "A forensic accountant stumbles onto a money-laundering network that runs through the city's most respected institutions — and the deeper she digs, the more certain she becomes that she is being watched.",
      posterUrl:
          'https://images.unsplash.com/photo-1675430663473-8f82a1fca63b?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1766844649143-af98d71e346b?w=800&h=450&fit=crop&auto=format',
      seasons: 2,
      episodes: 16,
      status: ShowStatus.ongoing,
      progress: 0.4,
      unwatchedEpisodes: 4,
      inWatchlist: true,
      cast: [
        CastMember(
          name: 'Petra Lund',
          role: 'Maya Solis',
          photoUrl:
              'https://images.unsplash.com/photo-1675430663473-8f82a1fca63b?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Marcus Vane',
          role: 'Inspector Drax',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
      ],
      episodeData: [
        Season(
          number: 1,
          episodes: [
            Episode(
              number: 1,
              title: 'The Ledger',
              duration: 48,
              synopsis:
                  'Maya finds a discrepancy that her superiors ask her to ignore.',
              watched: true,
              airDate: 'May 4, 2023',
            ),
            Episode(
              number: 2,
              title: 'Ghost Accounts',
              duration: 45,
              synopsis:
                  'Three shell companies trace back to one name that keeps getting redacted.',
              watched: true,
              airDate: 'May 11, 2023',
            ),
            Episode(
              number: 3,
              title: 'The Informant',
              duration: 50,
              synopsis: 'A contact offers Maya the full picture — for a price.',
              watched: false,
              airDate: 'May 18, 2023',
            ),
            Episode(
              number: 4,
              title: 'Blind Spot',
              duration: 52,
              synopsis: "Maya realizes she's been followed for weeks.",
              watched: false,
              airDate: 'May 25, 2023',
            ),
            Episode(
              number: 5,
              title: 'Protocol One',
              duration: 54,
              synopsis:
                  'The network makes its first move against Maya directly.',
              watched: false,
              airDate: 'Jun 1, 2023',
            ),
            Episode(
              number: 6,
              title: 'Clean Hands',
              duration: 49,
              synopsis: "Maya must decide how far she's willing to go.",
              watched: false,
              airDate: 'Jun 8, 2023',
            ),
          ],
        ),
        Season(
          number: 2,
          episodes: [
            Episode(
              number: 1,
              title: 'Aftermath',
              duration: 53,
              synopsis:
                  'Six months later — Maya lives off-grid and under a different name.',
              watched: false,
              airDate: 'Sep 5, 2024',
            ),
            Episode(
              number: 2,
              title: 'Surface Tension',
              duration: 47,
              synopsis: 'A familiar face pulls Maya back in.',
              watched: false,
              airDate: 'Sep 12, 2024',
            ),
          ],
        ),
      ],
    ),
    Show(
      id: 'meridian-falls',
      title: 'Meridian Falls',
      year: 2024,
      genres: ['Sci-Fi', 'Mystery'],
      synopsis:
          'Every ten years the residents of Meridian Falls vanish for exactly seventy-two hours. This year, for the first time, one person stays behind to witness what happens.',
      posterUrl:
          'https://images.unsplash.com/photo-1759354192456-71975b190c51?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1688678004647-945d5aaf91c1?w=800&h=450&fit=crop&auto=format',
      seasons: 1,
      episodes: 8,
      status: ShowStatus.ended,
      progress: 0.875,
      unwatchedEpisodes: 1,
      inWatchlist: false,
      cast: [
        CastMember(
          name: 'Priya Soh',
          role: 'June Vael',
          photoUrl:
              'https://images.unsplash.com/photo-1759354192456-71975b190c51?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Tom Adler',
          role: 'Sheriff Crane',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
      ],
      episodeData: [
        Season(
          number: 1,
          episodes: [
            Episode(
              number: 1,
              title: 'Evacuation Day',
              duration: 47,
              synopsis: 'June refuses to leave with the rest of the town.',
              watched: true,
              airDate: 'Apr 1, 2024',
            ),
            Episode(
              number: 2,
              title: 'Seventy-Two',
              duration: 45,
              synopsis:
                  'The clock starts and June begins to document the empty town.',
              watched: true,
              airDate: 'Apr 8, 2024',
            ),
            Episode(
              number: 3,
              title: 'Echoes',
              duration: 50,
              synopsis:
                  'June finds evidence that someone else has stayed behind — and left recordings.',
              watched: true,
              airDate: 'Apr 15, 2024',
            ),
            Episode(
              number: 4,
              title: 'The Hollow',
              duration: 52,
              synopsis:
                  'June follows the recordings into the forest at the edge of town.',
              watched: true,
              airDate: 'Apr 22, 2024',
            ),
            Episode(
              number: 5,
              title: 'Threshold',
              duration: 54,
              synopsis: 'June crosses into the hollow and reality shifts.',
              watched: true,
              airDate: 'Apr 29, 2024',
            ),
            Episode(
              number: 6,
              title: 'Visitors',
              duration: 48,
              synopsis: "June makes contact with something she can't explain.",
              watched: true,
              airDate: 'May 6, 2024',
            ),
            Episode(
              number: 7,
              title: 'Return',
              duration: 53,
              synopsis: 'The town returns. But something came back with them.',
              watched: true,
              airDate: 'May 13, 2024',
            ),
            Episode(
              number: 8,
              title: 'The Interval',
              duration: 58,
              synopsis:
                  'June prepares for the next ten years — and what she now knows is coming.',
              watched: false,
              airDate: 'May 20, 2024',
            ),
          ],
        ),
      ],
    ),
    Show(
      id: 'the-remnants',
      title: 'The Remnants',
      year: 2022,
      genres: ['Post-Apocalyptic', 'Drama'],
      synopsis:
          'Four years after a cascading infrastructure collapse, a young engineer travels the fractured coast seeking the people her city was built to save.',
      posterUrl:
          'https://images.unsplash.com/photo-1462715412043-8d09205be605?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1766844649143-af98d71e346b?w=800&h=450&fit=crop&auto=format',
      seasons: 2,
      episodes: 18,
      status: ShowStatus.ongoing,
      inWatchlist: false,
      cast: [
        CastMember(
          name: 'Kayla North',
          role: 'Solis',
          photoUrl:
              'https://images.unsplash.com/photo-1462715412043-8d09205be605?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Erik Sahl',
          role: 'The Keeper',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
      ],
      episodeData: [
        Season(
          number: 1,
          episodes: [
            Episode(
              number: 1,
              title: 'Day One Thousand',
              duration: 55,
              synopsis:
                  'Solis leaves the bunker for the first time since the collapse.',
              watched: false,
              airDate: 'Oct 6, 2022',
            ),
            Episode(
              number: 2,
              title: 'The Coast Road',
              duration: 52,
              synopsis:
                  'Solis follows the highway south and finds signs of new settlement.',
              watched: false,
              airDate: 'Oct 13, 2022',
            ),
          ],
        ),
      ],
    ),
    Show(
      id: 'accord',
      title: 'Accord',
      year: 2021,
      genres: ['Legal', 'Drama'],
      synopsis:
          'Inside an international arbitration court, three judges attempt to enforce a treaty between two nations on the edge of war — knowing that their ruling will determine whether diplomacy still means anything.',
      posterUrl:
          'https://images.unsplash.com/photo-1773592612185-bd985ac2bfe2?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1688678004647-945d5aaf91c1?w=800&h=450&fit=crop&auto=format',
      seasons: 4,
      episodes: 36,
      status: ShowStatus.ended,
      inWatchlist: true,
      cast: [
        CastMember(
          name: 'Simone Laval',
          role: 'Chief Arbiter Amara',
          photoUrl:
              'https://images.unsplash.com/photo-1773592612185-bd985ac2bfe2?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Kai Wren',
          role: 'Arbiter Soren',
          photoUrl:
              'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=120&h=120&fit=crop&auto=format',
        ),
      ],
      episodeData: [
        Season(
          number: 1,
          episodes: [
            Episode(
              number: 1,
              title: 'The Docket',
              duration: 51,
              synopsis:
                  'Three arbiters receive a case that no court has been willing to touch.',
              watched: false,
              airDate: 'Jun 14, 2021',
            ),
          ],
        ),
      ],
    ),
    Show(
      id: 'signal-lost',
      title: 'Signal Lost',
      year: 2023,
      genres: ['Mystery', 'Sci-Fi'],
      synopsis:
          'A radio telescope operator begins receiving transmissions encoded with her own voice — from dates that have not happened yet.',
      posterUrl:
          'https://images.unsplash.com/photo-1778710878550-04ef905c163a?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1766844649143-af98d71e346b?w=800&h=450&fit=crop&auto=format',
      seasons: 2,
      episodes: 14,
      status: ShowStatus.ongoing,
      unwatchedEpisodes: 6,
      inWatchlist: false,
      cast: [
        CastMember(
          name: 'Lia Moreau',
          role: 'Dr. Cassie Rao',
          photoUrl:
              'https://images.unsplash.com/photo-1778710878550-04ef905c163a?w=120&h=120&fit=crop&auto=format',
        ),
      ],
      episodeData: [
        Season(
          number: 1,
          episodes: [
            Episode(
              number: 1,
              title: 'First Contact',
              duration: 46,
              synopsis: 'Cassie receives the first transmission at 3:17 AM.',
              watched: false,
              airDate: 'Sep 21, 2023',
            ),
          ],
        ),
      ],
    ),
    Show(
      id: 'liminal',
      title: 'Liminal',
      year: 2024,
      genres: ['Psychological', 'Drama'],
      synopsis:
          'A grief counselor begins attending her own group sessions — anonymously — after the death of her partner, and discovers that her grief is being used to access something deep inside her.',
      posterUrl:
          'https://images.unsplash.com/photo-1776275459073-25a6b864c483?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1688678004647-945d5aaf91c1?w=800&h=450&fit=crop&auto=format',
      seasons: 1,
      episodes: 6,
      status: ShowStatus.upcoming,
      inWatchlist: true,
      cast: [
        CastMember(
          name: 'Noa Bern',
          role: 'Dr. Wren Solano',
          photoUrl:
              'https://images.unsplash.com/photo-1776275459073-25a6b864c483?w=120&h=120&fit=crop&auto=format',
        ),
      ],
      episodeData: [
        Season(
          number: 1,
          episodes: [
            Episode(
              number: 1,
              title: 'The First Meeting',
              duration: 48,
              synopsis: 'Wren sits in a circle she usually leads.',
              watched: false,
              airDate: 'Nov 7, 2024',
            ),
          ],
        ),
      ],
    ),
    Show(
      id: 'cascade-effect',
      title: 'Cascade Effect',
      year: 2022,
      genres: ['Thriller', 'Action'],
      synopsis:
          'When a critical infrastructure AI begins making unauthorized decisions to protect human life, an ethicist and a systems engineer race to determine whether its choices constitute sentience — before the government shuts it down permanently.',
      posterUrl:
          'https://images.unsplash.com/photo-1678918549313-cbaf32e5a1c5?w=400&h=600&fit=crop&auto=format',
      backdropUrl:
          'https://images.unsplash.com/photo-1766844649143-af98d71e346b?w=800&h=450&fit=crop&auto=format',
      seasons: 3,
      episodes: 24,
      status: ShowStatus.ended,
      inWatchlist: false,
      cast: [
        CastMember(
          name: 'Alex Soren',
          role: 'Dr. Mara Osei',
          photoUrl:
              'https://images.unsplash.com/photo-1525547843489-d0aab95e5ce1?w=120&h=120&fit=crop&auto=format',
        ),
        CastMember(
          name: 'Nils Faber',
          role: 'Director Chen',
          photoUrl:
              'https://images.unsplash.com/photo-1678918549313-cbaf32e5a1c5?w=120&h=120&fit=crop&auto=format',
        ),
      ],
      episodeData: [
        Season(
          number: 1,
          episodes: [
            Episode(
              number: 1,
              title: 'Anomalous Behavior',
              duration: 50,
              synopsis:
                  'The AI flags a decision as non-compliant — then makes it anyway.',
              watched: false,
              airDate: 'Feb 3, 2022',
            ),
          ],
        ),
      ],
    ),
  ];

  static const _comments = <Comment>[
    Comment(
      id: 'c1',
      username: 'celestialwatcher',
      avatar:
          'https://images.unsplash.com/photo-1525547843489-d0aab95e5ce1?w=80&h=80&fit=crop&auto=format',
      text:
          'The third act completely blindsided me. I had to stop and process for a moment before finishing. Absolute masterclass in tension-building.',
      time: '2h ago',
      likes: 48,
      spoiler: false,
    ),
    Comment(
      id: 'c2',
      username: 'kinoscope',
      avatar:
          'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=80&h=80&fit=crop&auto=format',
      text:
          'The cinematography is doing so much heavy lifting here. Every frame feels deliberately composed. Loved the symmetry throughout.',
      time: '5h ago',
      likes: 31,
      spoiler: false,
    ),
    Comment(
      id: 'c3',
      username: 'vaultkeeper',
      avatar:
          'https://images.unsplash.com/photo-1778710878550-04ef905c163a?w=80&h=80&fit=crop&auto=format',
      text:
          'The reveal in the second act changes everything you thought you understood about the first forty minutes. Go back and rewatch after you finish.',
      time: '1d ago',
      likes: 72,
      spoiler: true,
    ),
    Comment(
      id: 'c4',
      username: 'reelcritic',
      avatar:
          'https://images.unsplash.com/photo-1614201842267-206a09286c3b?w=80&h=80&fit=crop&auto=format',
      text:
          "Pacing is deliberately slow in the first half but it earns every minute. By the time the pieces click, you're completely locked in.",
      time: '2d ago',
      likes: 19,
      spoiler: false,
    ),
    Comment(
      id: 'c5',
      username: 'silhouette__fx',
      avatar:
          'https://images.unsplash.com/photo-1773592612185-bd985ac2bfe2?w=80&h=80&fit=crop&auto=format',
      text:
          "One of the most confident directorial voices I've seen in years. Nothing feels accidental. Added to my rewatch queue immediately.",
      time: '3d ago',
      likes: 55,
      spoiler: false,
    ),
    Comment(
      id: 'c6',
      username: 'framerate',
      avatar:
          'https://images.unsplash.com/photo-1462715412043-8d09205be605?w=80&h=80&fit=crop&auto=format',
      text:
          'Score deserves its own conversation. The way the music undercuts expectation in the final sequence is something else entirely.',
      time: '4d ago',
      likes: 38,
      spoiler: false,
    ),
  ];

  @override
  Future<List<Show>> getShows() async => _shows;

  @override
  Future<Show?> getShow(String id) async {
    for (final show in _shows) {
      if (show.id == id) return show;
    }
    return null;
  }

  @override
  Future<List<Movie>> getMovies() async => _movies;

  @override
  Future<Movie?> getMovie(String id) async {
    for (final movie in _movies) {
      if (movie.id == id) return movie;
    }
    return null;
  }

  @override
  Future<Season?> getSeason(String showId, int seasonNumber) async {
    for (final show in _shows) {
      if (show.id == showId) {
        for (final season in show.episodeData) {
          if (season.number == seasonNumber) return season;
        }
      }
    }
    return null;
  }

  @override
  Future<List<Comment>> getComments() async => _comments;

  @override
  Future<List<SearchResult>> search(String query) async {
    final results = <SearchResult>[
      for (final movie in _movies)
        SearchResult(
          type: ContentType.movie,
          id: movie.id,
          title: movie.title,
          year: movie.year,
          genres: movie.genres,
          posterUrl: movie.posterUrl,
        ),
      for (final show in _shows)
        SearchResult(
          type: ContentType.show,
          id: show.id,
          title: show.title,
          year: show.year,
          genres: show.genres,
          posterUrl: show.posterUrl,
        ),
    ];
    return results.where((result) => result.matches(query)).toList();
  }
}
